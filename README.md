# Julia-notes
Julia学习笔记
[TOC]
## 基本用法
### 进入和退出packge模式
进入"]"
退出 “Backspace”
###进入、退出shell模式
进入";"
退出 “Backspace”

### Jupyter 可作为一个线上Julia笔记本
类似methamatica的notebook。可以针对各种语言。


##一些有趣或者有用的包
（以字母为序）
主要来自2018.9.26 Erik的课上介绍
要找这些包很容易，上GitHub搜就是了。使用的话也很容易
    julia> using ForwardDiff
如果没被放到Julia官方的库中，就把网址给上即可，如
    julia> add https://github.com/JuliaApproximation/***.git

Julia各种包的官网在：https://pkg.julialang.org/

###ApproxFun.jl
把任何一个函数变成多项式，这样可以轻松做微积分，求根。当然精度不那么高了。

###BenchmarkTools
https://github.com/JuliaCI/BenchmarkTools.jl

###Calculus 微分积分
https://github.com/JuliaMath/Calculus.jl

###CAS 针对csv文件的读写
https://github.com/JuliaData/CSV.jl

### DifferentialEquations 数值解微分方程
https://github.com/JuliaDiffEq/DifferentialEquations.jl
这个包看起来很完整了。应该属于Julia的一个重量级的功能。

###Documenter 自动生成说明文档
https://github.com/JuliaDocs/Documenter.jl

### ForwardDiff.jl 与ReverseDiff 功能类似，对象不同。
貌似是可以暂时不做求导，等到需要的时候根据对象是什么分别求导。

###FunctionalCollections
https://github.com/JuliaCollections/FunctionalCollections.jl

###Gadfly 又一个画图的包，深受ggplot2影响，GitHub上也很活跃。
https://github.com/GiovineItalia/Gadfly.jl

###HDF5 一种数据存储格式
https://github.com/JuliaIO/HDF5.jl
https://github.com/JuliaIO/JLD2.jl
可以用于存储和读写

###IJulia 一个类似于Jupyter的互动的可以网页上显示的Julia终端
https://github.com/JuliaLang/IJulia.jl

###Interact 可视化的一种办法
https://github.com/JuliaGizmos/Interact.jl

###JuMP Modeling language for Mathematical Optimization (linear, mixed-integer, conic, semidefinite, nonlinear)
https://github.com/JuliaOpt/JuMP.jl

###PackageCompiler 把开发的包编译成可执行文件
https://github.com/JuliaLang/PackageCompiler.jl

###Profiling  可以用于调试程序，优化程序
Julia内置的，它可以看那些命令被调用了多少次。
###PyCall 在Julia里调用Python的命令
https://github.com/JuliaPy/PyCall.jl

###Rewrite.jl 重写成更用户友好的表达式，比如归一化，整理等。
https://github.com/HarrisonGrodin/Rewrite.jl

###Unitful 在各种单位制下的物理常数
https://github.com/ajkeller34/Unitful.jl


##一些有趣或者有用的“社区” 
（以字母为序）
###JuliaData 各种和数据打交道的包
https://github.com/JuliaData/

### JuliaGraphs 跟图相关的（不是用数据画图）
https://github.com/JuliaGraphs

###JuliaPlots 各种跟作图相关的包
https://github.com/JuliaPlots
甚至还有相应的网站 http://docs.juliaplots.org/latest/
但也并不是所有的跟画图相关的都在这里，比如很活跃的gadfly

###JuliaPy 将Python和Julia联系起来的包
https://github.com/JuliaPy

###JuliaStats 用Julia做统计
https://github.com/JuliaStats

##使用RCall调用R中的各种包
以使用R中的ggplot2为例，有了它就不需要别的画图工具了。
1. 安装R，Ubuntu下 sudo apt-get install r-base
2. 在R下安装ggplot2的包
sudo R 进入R，（sudo进入后安装的才是全局可用的包，否则可能会麻烦，比如要人为设置路径啥的，并没有测试）
install.packages()会弹出对话框，让选安装什么；或者直接install.packages("ggplot2")
3. 在Julia下，package模式中, add RCall
注意，以后可能需要新的包，每次在R中新安装了包之后，在Julia要重新做，命令是 build RCall
4. using RCall; 
@rlibrary ggplot2
就可以用了。
