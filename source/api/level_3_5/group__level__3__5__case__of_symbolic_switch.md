# Construct "switch" control structure in symbolic graph

Here I use the keyword case_of. To provide a "switch" control structure within NNC has some nice properties even though you can simulate this with a while loop technically.

1. More optimal memory allocation: with "switch" control structure, memory can be multiplexed for each code path because they are mutually exclusive.

2. No tape should be used within each branch: if we simulate with a "while" loop, any results from within the "switch" statement has to be kept on the tape, which is inefficient because you don't need any tape for the "switch" statement other than record which path it is taken.

The particular "switch" control structure provided here is a multi-way structured "switch". Each branch is a sub-graph, so it is well-scoped. A node branch out based on the case_of condition return value to either of the branch (numbering from 0 to n, -1 means no path taken). If no path taken, the output tensors will be assigned with the default tensors and continue. Otherwise the computation within the sub-graph will be carried out and the output tensors will be assigned with the tensors specified within that sub-graph and continue.

If we want to consider speculative execution in the future, we need to revisit our memory allocation scheme. 
