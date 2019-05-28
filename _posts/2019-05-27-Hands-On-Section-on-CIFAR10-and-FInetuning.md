---
title: "Hands on Section on CIFAR 10 and Finetuning"
---

This was a hands on session with Sarthak Sir on Google Colab, We coded our Deep First Network with torch there. and the code for it is as shown.
I will also write the about the cell codes as well for reference.<br>

<i> This is the part where we import all the modules and also rename them for our convenience.</i><br>

{% highlight ruby %}
import torch
import torch.nn as nn
import torchvision.datasets as dsets
import torchvision.transforms as transforms
from torch.autograd import Variable
import torchvision
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import numpy as np
{% endhighlight %}

<i> Now that we have imported all the required Libraries we need to look at our Training set and torch has the CIFAR10 Dataset avialabe so just as a part of our introduction we don't need to write our own classifier but when we do something hardcore we will have to do it. But for now we will use the inbuild Dataset.</i>