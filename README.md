# SharedPreferenceModel
Model of a stress gradient with shared preferences, implemented in MATLAB using integrodifference equations.

**Description:** A model to simulate species distributions along a 1D-stress gradient *x*. Species can grow, compete, and disperse along the gradient.
Each species is characterized by a spatial growth function, which determines the growth rate at each position along the gradient. This curve is shaped by species specific traits, namely the max. growth rate R, the tolerance T and the optimum position x~.
To achieve shared preferences the optimum positions of all species is set to the benign end. In the model, the benign end is located at x = 0 (left) and the hostile end at x = 1 (right).
Further information about the model can be obtained here: (reference)

**Data:** Results of some simulations is included in the "Data" folder. Additional Figures can be generated via the "figures" script.

**Code:** The model can be executed through "SharedPreferenceModel", which is the main script. Model options can be set at the beginning through the "opt" struct. Parameters are set below with the "p" struct.

Notice: Please acknowledge the use of the above model in any publications.
Reference: Schucht, T. and Blasius, B., 2024: Shared preferences along stress gradients: how a growth-tolerance trade-off drives unimodal diversity and trait lumping". *Not published yet*



