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

 Now that we have imported all the required Libraries we need to look at our Training set and torch has the CIFAR10 Dataset avialabe so just as a part of our introduction we don't need to write our own classifier but when we do something hardcore we will have to do it. But for now we will use the inbuild Dataset.
 <i> We will now print the class of the trainset trainloader testset testloader and make them Iterrateable objects so that they can be fed to the network. </i>

{% highlight ruby %}
print(type(trainset))
print(type(trainloader))
print(type(testset))
print(type(testloader))
#converting into an iterable object
trainiter = iter(trainloader)
#print("Number of train samples",len(list(trainiter)))
testiter = iter(testloader)
#print("Number of test samples",len(list(testiter)))
#images, labels = trainiter.next()
{% endhighlight %}

{% highlight ruby %}
#Getting the dataset
transform = transforms.Compose([transforms.ToTensor()])
trainset = torchvision.datasets.CIFAR10(root='./data', train=True, download=True,transform=transform)
trainloader = torch.utils.data.DataLoader(trainset, batch_size=64, shuffle=True, num_workers=2)

testset = torchvision.datasets.CIFAR10(root='./data', train=False, download=True,transform=transform)
testloader = torch.utils.data.DataLoader(testset, batch_size=64, shuffle=False, num_workers=2)

classes = ('plane', 'car', 'bird', 'cat','deer', 'dog', 'frog', 'horse', 'ship', 'truck')
#LABELS 0,1,2,3,4,5,6,7,8,9

{% endhighlight %}

{% highlight ruby %}

{% endhighlight %}