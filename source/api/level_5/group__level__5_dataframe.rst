What is “dataframe” in ML?
==========================

A large part of machine learning consists of go through data, process them to a shape / form that makes sense, and pass that into the model to train. Deep learning frameworks such as TensorFlow or PyTorch provides some dataset APIs for this purpose. It is convenient for these frameworks because by being Python, people can use Pandas to process the data. In Pandas, this is called Dataframe, which again, imitates R language.

Another interesting observation comes from recent (2018) release of Create ML framework from Apple. It provides a very close to Pandas style data process API (MLDataTable) but in Swift. This implementation is important because it provides a survey point other than Python.

Comparing to Python, Swift is a stronger typed language. Though all being high-level, they all have pretty good string support (of course!), operator overloading, and polymorphism. String support makes column naming natural, Operator overloading makes conditioning and filtering easier, and polymorphism makes column type representation straight-forward. These, unfortunately, are the challenges I need to face when implementing in C with the eye towards that later the similar ideas can be implemented on top on a high-level language based on this one.

It seems I haven’t answered the most crucial question yet: what’s special about these data process APIs? It is easier to answer this to first see what Pandas or MLDataTable does.

-  They both represent data as tables. Each column represents different type of the data (time, nd-array, scalar or string). As such, they both have API to add / remove / rename columns, and load tabular data from disk.

-  They both provide API to filter (remove / add) rows, and derive new column from existing columns.

-  Pandas provides more API for data alignment (merge columns from different tables into one table), and compute statistics (group rows by some criteria, and compute min / max / std / mean within that group).

-  MLDataTable provides API to batching data (random split) which covered in TensorFlow / PyTorch’s Dataset API as well.

It turns out when you have a noisy dataset, these functionalities are useful to remove unwanted data quickly. If you have a relatively clean dataset, it also allows you to prepare data in a more elegant way. For NNC, the interesting requirements are:

1. Represents scalars, tensors, string as columns; columns can be named.

2. New columns can be derived, from existing ones.

3. Rows can be filtered, grouped, and statistics can be computed.

4. Columns can be aligned, with some given indexes.

5. All these can be done efficiently, on a scale of hundreds of Gigabytes data.
