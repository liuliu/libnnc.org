# Why to support comma-separated-values files in dataframe?

C can be used as a parser. It usually can be fast. But most of them can be buggy and has bugs that can either crash, be exploited, or simply incorrect. There really isn't much motivation for me to start write a parser, even as simple as for CSV files.

However, it does brought to my attention that a full-speed (defined by saturating the PCIx4 for SSD) implementation would be beneficial. I am also started to use nnc in many places that is handy to load a csv file and generate some tensors out of it.

This implementation plan to use a variant of the two-pass approach documented in https://www.microsoft.com/en-us/research/uploads/prod/2019/04/chunker-sigmod19.pdf while first implemented in https://github.com/wiseio/paratext. It is differentiated from these two in these particular ways:

1. The first pass will not only find the quotes and even / odd CRLF, but also collect statistics on how many lines assuming the first CRLF is within quote / outside of the quote; 2. The second pass will do a copy into a continuous page mirrors the original csv file, but null-terminate each column, and assign the start pointer for each.

The speculative approach while interesting, for many-core system implementation, it can be challenging and the worse-case scenario is indeed worse.

The implementation itself follows https://tools.ietf.org/html/rfc4180, with only customization of delimiters (so it can support table-separated-values) and quotes (so you can choose between " and '). Escaping only supports double-quotes for whatever quote symbol you elect. 
