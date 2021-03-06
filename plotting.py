import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

file=r'C:\User\Username\'
reliability=pd.read_excel(file+r'\ReliabilityR.xlsx')
power=pd.read_excel(file+r'\PowerR.xlsx')


def plot(folder, df, m):
    size = int(len(set(df["size"])))
    pos=list(range(0, size//2))*2
    fig, axs = plt.subplots(size//2, 2, sharex=True, sharey=True, figsize=(15, 15))
    if mode=="power":
        fig.suptitle("Puissance du test T de Student")
    if mode=="reliability":
        fig.suptitle("Fiabilité du test T de Student")
    fig.tight_layout(pad=3.0)
    
    for i, j in zip(range(len(pos)), set(df["size"])):
        x=[]
        y_1=[]
        y_2=[]
        for k in range(len(df)):
            if df.at[k, "size"]==j:
                if mode=="power":
                    x.append(df.at[k, "delta"])
                if mode=="reliability":
                     x.append(df.at[k, "factor"])                   
                y_1.append(df.at[k, "ttest"])
                y_2.append(df.at[k, "welch"])
        axs[pos[i], int(i/size+0.5)].set_title(f"n = {j}")
        axs[pos[i], int(i/size+0.5)].plot(x, y_1, "r^")
        axs[pos[i], int(i/size+0.5)].plot(x, y_1, color="red",lw=1, label="Sans Welch")
        axs[pos[i], int(i/size+0.5)].plot(x, y_2, "bo")
        axs[pos[i], int(i/size+0.5)].plot(x, y_2, color="blue",lw=1, label="Avec Welch")
        axs[pos[i], int(i/size+0.5)].legend(loc="lower right", shadow=True, fancybox=True)
        if mode=="power":
            axs[pos[i], int(i/size+0.5)].hlines(y=0.8, xmin=0.25, xmax=2, color="green", lw=1)
        if mode=="reliability":
            axs[pos[i], int(i/size+0.5)].hlines(y=5, xmin=1, xmax=4, color="green", lw=1)
    for ax in axs.flat:
        if mode=="power":
            ax.set(xlabel="distance", ylabel="puissance")
        if mode=="reliability":
            ax.set(xlabel="facteur", ylabel="fiabilite (%)")
        ax.label_outer()
    fig.savefig(folder+f"\\{m}.png")

mode="reliability"
plot(file, reliability, mode)
mode="power"
plot(file, power, mode)
