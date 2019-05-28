---
title: "Hands on section for Deep Net on CIFAR10 data set for IMage classification on Google Collab and also Fine tuning a network for CIFAR 100 Network."
---

This was a hands on session with Sarthak Sir on Google Colab, We coded our Deep First Network with torch there. and the code for it is as shown.
I will also write the about the cell codes as well for reference

'''sh
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
```