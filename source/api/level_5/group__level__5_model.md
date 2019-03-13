# Models, layers, and Keras

With Keras API in mind, this model implementation essentially is a light-weight way to group neural network layers together. This is a rare case in NNC (or ccv in general) where Object-Oriented programming makes sense. I borrowed heavily from Objective-C / C++ to implement this Object-Oriented interface.

Now back to elaboration of the Model interface. It is specifically designed with Keras in mind, asking question: If we are going to build Keras high-level API in any languages (Ruby, Python, Swift, Julia), what's the underlying C interface would look like? Here is your answer (hint: it looks very much like just Python Keras API).

A model consists of a set of inputs and outputs. This sounds very much like what "Command" is in Level-1 APIs, however, they are different: a model is stateful. For example, a convolution command takes 3 inputs: image, kernel weight and bias, has 1 output: image. A convolution model takes 1 input: image, and 1 output: image. kernel weight and bias are internal states to the model (in Keras, it is called "layer" for convolution, and model means a set of layers. In NNC, that kind of differentiation feels superficial, therefore, a layer is a model).

A model can be combined, and a new model can be a combination of other models.

The simpler composed model is the sequential model. A sequential model is a model that consists a sequence of models that contains one input and one output. The output of the earlier model feed into the later one, thus, a sequential evaluation path. 
