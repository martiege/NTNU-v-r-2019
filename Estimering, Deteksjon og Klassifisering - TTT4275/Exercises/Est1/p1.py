import numpy as np
import matplotlib.pyplot as plt
%matplotlib notebook
plt.rcParams["figure.figsize"] = [8,6]

# Parameters 
A = 1
sigma = np.sqrt(np.power(10,-np.linspace(0,3)))
N = 1000
numSamp = 10000

res = 0*sigma
for ind,s in enumerate(sigma):
    x = A + np.random.normal(0,s,(N,numSamp))
    m = np.median(x,axis=0)
    e = m - A
    res[ind] = np.mean(e**2) 

fig,ax = plt.subplots()
ax.plot(sigma,res,label="median")
ax.plot(sigma,sigma**2/N,label="sample mean")
ax.set_ylabel(r"var($\hat A$)")
ax.set_xlabel(r"$\sigma^2$")
ax.legend()
