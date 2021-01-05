.. nnc documentation master file, created by
   sphinx-quickstart on Tue Jul 17 23:18:56 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

NNC: Neural Network Collection
==============================

.. toctree::
   :maxdepth: 3
   :hidden:

   overview.rst
   tech/index.rst
   api/index.rst
   Swift for NNC <https://libnnc.org/s4nnc/>

At the end of 2014, when I was looking at these new computer vision models with complex neural network architectures, it became apparently clear what `ccv <http://libccv.org>`_ has implemented (the neural network) as one of many computer vision algorithms will be the only algorithm matters in the future. More importantly, what I have in `ccv <http://libccv.org>`_ is a early attempt, but ill-equipped to support these advanced architectures. There is no multi-way networks, no customizable losses, and no automatic differentiation.

Then, NNC started exactly as *yet another deep learning framework*. By starting from scratch enables me to toy with some new ideas on the implementation, and some of these ideas, after implemented, has some interesting properties. After 4 years, and given the fresh new takes on both APIs and the implementation, I am increasingly convinced this will be a good foundation to implement high-level deep learning APIs in any host languages (Ruby, Python, Java, Kotlin, Swift etc.).

Like every other deep learning framework, NNC operates dataflow graphs. Data dependencies on the graph are explicitly specified. NNC also keeps the separation of symbolic dataflow graphs versus concrete dataflow graphs. Again, like every other deep learning framework, NNC supports dynamic execution, which is called dynamic graph in NNC.

There are some unique interesting bits:

 * NNC supports control flows, with a very specific while loop construct and multi-way branch construct;

 * NNC implements a sophisticated :doc:`tensor allocation algorithm <tech/nnc-alloc>` that treats tensors as a region of memory, which enables tensor partial reuse;

 * The above allocation algorithm handles control flows, eliminates data transfers for while loop, and minimizes data transfers for branching;

 * :doc:`Dynamic execution <tech/nnc-dy>` in NNC is implemented on top of its static graph counterpart, thus, all optimization passes available for static graph can be applied when doing automatic differentiation in the dynamic execution mode;

 * Because the dataflow graph is fully specified, it can be :doc:`statically scheduled <tech/nnc-schd>` to execute in parallel on the hardware trivially, with all the control flows in place;

 * A `Keras <https://keras.io>`_-like interface is implemented, making high-level deep learning concepts accessible through C;

 * Clear and concise :doc:`C interface <api/index>` enables integrations beyond Python for full-range of deep learning framework functionalities.

Over the next a few months, I will write more about this. There are still tremendous amount of work ahead for me to get to a point of release.

 * :doc:`overview`
 * :doc:`tech/index`
 * :doc:`api/index`
 * `Swift for NNC </s4nnc/>`_
