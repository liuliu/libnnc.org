Construct a "while" loop in a symbolic graph
============================================

In NNC, a computation graph cannot allow cycles. Thus, there is no flexible way to express loops.

A little survey on this problem:

-  Caffe2 supports specific type of recurrent neural network.

-  TensorFlow as it stands, supports while construct. Its while construct is very straightforward, a body and a condition is provided, you can construct whatever graph as you want.

-  mxnet supports recurrent neural network by unrolling it into normal none-looped graph.

-  Theano supports "scan" ops, which is a terminable loop (with loop variant, known as sequence).

-  CNTK supports this with custom BrainScript. Within BrainScript, you can access the previous state in a function, therefore, effectively supports calling a method multiple times (looping over).

Of above, Caffe2 and mxnet gave up on supporting generic loop for performance reasons. TensorFlow supports generic while loop, with all the trouble it may introduce (see the Nested while loop bug in TensorFlow that recently fixed). Theano picked a point seems pretty sweet, although there are limitations. CNTK's BrainScript is a DSL, they can do whatever they want with the drawback now that they need to implement a language runtime. TensorFlow, Theano and CNTK all support auto-differentiation over the while loop with tape (Wengert list).

A simple way to support loop is to support conditional jump. In fact, conditional jump is a more generic way of doing loops. However, if you put this into the consideration that fully differentiable computation graph wanna to be supported, it is terrible. With conditional jump, it is really hard for you to know which tensor is used where, thus keep track for reverse accumulation (backward propagation). There is no counter or whatsoever, it is pretty hard to trace back on which line is executed how many times. Compounding this with NNC's promise that as long as it shows on the graph can be "parallel" computed, it will be parallel computed, it is close to impossible to track if conditional jump used in its raw form. Certain restrictions must be applied to how to do the loop. The compromise comes from closer examination of NNC's preferences.

NNC prefers to have the graph without cycles. It also prefers to be fully differentiable. Another important criteria is that most functions in NNC require SSA (Static Single Assignment) representation. With these in mind, supporting while loop has to be strict.

Luckily, there are well-formalized way of supporting this in literature and practice. Because it is well-formalized, translating this into existing NNC implementation is actually pretty straightforward. We are going to introduce a special version of while loop. In literature that discussed about SSA, it may be called parameterized loop. For us, it works like this:

To construct a while loop for existing NNC graph, you need to be able to separate the existing graph into two sub-graphs.

The while-loop sub-graph (WL sub-graph) contains a set of incoming nodes (I-nodes), Condition false output nodes (CFO-nodes) and end nodes (E-nodes). Each set have its own properties, but in short, all incoming edges to the WL sub-graph connect to one of the I-nodes, but nothing else. All outgoing edges from the WL sub-graph connect to one of the CFO-nodes, but nothing else. A nodes can be either a I-node, CFO-node or E-node, non-exclusively.

There are also 3 types of tensors used for all nodes in WL sub-graph: Input tensors (I-tensors) are tensors that are inputs to some nodes, and will never be outputs. Output tensors (O-tensors) are tensors that are outputs from some nodes, but never be inputs to any nodes. I-tensors can be outputs from some nodes that outside of WL sub-graph. O-tensors can be inputs to some nodes that outside of WL sub-graph. Internal tensors (IN-tensors) are not visible outside of WL sub-graph, therefore, they can be both inputs and outputs of some nodes inside the sub-graph. Some tensors can be feedback into the WL sub-graph, given either O-tensors or IN-tensors. A parameter map can be given in these cases to describe which maps to what.

The way to drive a WL sub-graph like this: the WL sub-graph runs until all CFO-nodes are reached. At this point, the while\_f condition is checked. If true, we continue until all the end-nodes are reached. At this point, we increase the counter, reconfigure the WL sub-graph with parameter map, and run from I-nodes all over again. When reached all CFO-nodes, the condition is checked again, if false, WL sub-graph terminates, and the graph continues from the nodes that are pointed by CFO-nodes.

Given these constraints, doing automatic differentiation is not that hard any more. A WL sub-graph, from the whole graph's point of view, is just a giant command supports both forward / backward operations, with some extra information passed around in the form of userdata (tape).

For WL sub-graph, we can continue to leverage the compile / backward function that already written for symbolic graph as well.

For compile function, we just need to take care of parameter maps (these need to be converted into binded tensors).

For backward function, we need to convert parameter maps from assigner (thus, y = x) to accumulator (x += y).

This function will replace the nodes that it affects to one sub-graph node. Thus, how to drive this sub-graph is opaque. Its backward form is opaque as well.

There are no connection between its nodes and the outside graph nodes other than the three sets:

1). Incoming nodes, the set of nodes that contains the incoming edges from outside, they cannot have edges points by inside nodes. The sub-graph computation starts from these incoming nodes; 2). Condition false output nodes, when condition is false, we will break out of this while loop, these nodes pointing to the outside nodes, but no inside nodes; 3). End nodes, the set of nodes that marks the end of the while body, and after these nodes are executed, we will return to the incoming nodes. These end nodes shouldn't have any edges pointing to inside nodes (OK if end nodes are condition true output nodes as well);

Since these will become a sub-graph (which, to its owner graph, just simple "node"), it will have inputs and outputs. Besides that, the loop body needs to be parameterized to be SSA compliant (see: https://www.cs.cmu.edu/~fp/courses/15411-f13/lectures/06-ssa.pdf). Thus, a list of body parameters need to be provided.
