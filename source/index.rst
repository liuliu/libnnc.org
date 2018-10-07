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

A Proof Of Concept
------------------

NNC is a tiny deep learning framework I was working on for the past three years. Before you close the page on *yet another deep learning framework*. let me quickly summarize why: starting from scratch enables me to toy with some new ideas on the implementation, and some of these ideas, after implemented, has some interesting properties.

After three years, and given the fresh new takes on both APIs and the implementation, I am increasingly convinced this will also be a good foundation to implement high-level deep learning APIs in any host languages (Ruby, Python, Java, Kotlin, Swift etc.).

What are these fresh new takes? Well, before we jump into that, let's start with some not-so-new ideas inside NNC: Like every other deep learning framework, NNC operates dataflow graphs. Data dependencies on the graph are explicitly specified. NNC also keeps the separation of symbolic dataflow graphs v.s. concrete dataflow graphs. Again, like every other deep learning framework, NNC supports dynamic execution, which is called dynamic graph in NNC.

With all that get out of the way, the interesting bits:

 * NNC supports control flows, with a very specific while loop construct and multi-way branch construct;

 * NNC implements a sophisticated :doc:`tensor allocation algorithm <tech/nnc-alloc>` that treats tensors as a region of memory, which enables tensor partial reuse;

 * The above allocation algorithm handles control flows, eliminates data transfers for while loop, and minimizes data transfers for branching;

 * :doc:`Dynamic execution <tech/nnc-dy>` in NNC is implemented on top of its static graph counterpart, thus, all optimization passes available for static graph can be applied when doing automatic differentiation in the dynamic execution mode;

 * Tensors used during the dynamic execution can be reclaimed, there is no explicit tape session or ``requires_grad`` flag;

Over the next a few months, I will write more about this. There are still tremendous amount of work ahead for me to get to a point of release.

:doc:`api/index`.
