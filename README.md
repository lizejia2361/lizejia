**数字组考核汇报**

**汇报人：李泽嘉**

**选择题目：16位有符号加速乘法器实现**

​		由于在GEEK中也有学习过quartus和modelsim的使用，所以也就跳过了这两个软件的学习过程，直接进行乘法器的学习及实现。

​		首先，普通的乘法器是很好实现的。例如，一个最简单的二位乘法器只需要四个与门和两个半加器就可以实现。

Figure 一图为我在LogicCircuit这个软件中做的乘法器，二图为modelsim仿真结果（ [multiplier_2x2.v](代码\multiplier_2x2.v)， [multiplier_2x2_tb.vt](代码\multiplier_2x2_tb.vt)  ）

![](https://github.com/lizejia2361/lizejia/blob/main/LogicCircuit.png)

![](https://github.com/lizejia2361/lizejia/blob/main/wave1.jpg)

但是，这样一个二位的乘法器，也只能实现3以内的乘法。想要进行更大的数的乘法就要对加法器进行“位拓展”，当然这也是不难实现的。
![](https://github.com/lizejia2361/lizejia/blob/main/length.png)类似这样。

 

  	当然了，这道考核题并没有那么简单，认真读完题目后，我总结了以下需要注意，克服完成的地方：

\1.   乘法器的位数为16位

\2.   乘法器要实现的是有符号数的乘法，要能进行负数的乘法

\3.   乘法器是一个加速乘法器，需要有加速的能力以节省资源

​		首先第一点，乘法器的位数为16位，这意味着这个乘法器可以进行两个65535以内的数相乘的运算。而位数的增加虽然意味着运算范围的增大，但也会增加硬件的成本和功耗。因此，要点三，对乘法器进行加速就显得非常有必要。

​		第二是有符号数，由于在假期里，高鹏老师曾让我们学习过一本名叫Verilog_VLSI的书。在书中有一个实验是完成一个加法器实现两个有符号数的加减，于是我想先学习如何实现有符号数的乘法器。为此，我先是在哔站上找了一些视频，重温了一下计算机是如何实现乘法的。 
![](https://github.com/lizejia2361/lizejia/blob/main/progress1.png)

​		从图中可以知道，乘法运算时，需要用到三个寄存器和一个加法器。一个四位的寄存器用来存储乘数（由于这是一个四位的乘法器），两个八位的寄存器分别存储被乘数和乘积，同时用来存储被乘数的寄存器还应该有左移的功能，存储乘数的寄存器有右移功能用来对齐。

下图为工作流程：

![](https://github.com/lizejia2361/lizejia/blob/main/progress2.png)
​		但是像上图这样进行乘法运算的话左移，右移，相加都需要一个时钟周期，如果是一个32位的乘法器，进行一次运算就需要将近一百个时钟周期，因此这个乘法器还需要优化。最简单的就是让这三步并行起来，因为三者是不冲突的。下图就是并行后的流程图。

![](https://github.com/lizejia2361/lizejia/blob/main/progress_improve.png)

​	视屏来源（【计算机组成 4 乘法器和除法器】https://www.bilibili.com/video/BV1uY411J7Vs?p=4&vd_source=59c53bb9449f5755f3333acdc359b185）

​		知道了计算机如何进行乘法运算及简单优化后，我又去CSDN上找了有符号数的乘法器的实现

（https://blog.csdn.net/vivid117/article/details/101427302?ops_request_misc=&request_id=&biz_id=102&utm_term=%E5%A6%82%E4%BD%95%E5%AE%9E%E7%8E%B0%E6%9C%89%E7%AC%A6%E5%8F%B7%E6%95%B0%E4%B9%98%E6%B3%95%E5%99%A8&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-101427302.142）

​		在这个作者的文章中，他用了两种方式来实现乘法器，分别是串行乘法器和流水线乘法器，并在最后介绍了有符号数八位乘法器的实现。串行乘法器和流水线乘法器这里就不在深究，只在这里说说两者的特点。

1.串行乘法器的核心是移位相加算法，两个N位二进制数x、y的乘积用简单的方法计算就是利用移位操作来实现。

优点：所**占用的资源**是所有**类型乘法器中最少的**，在低速的信号处理中有着广泛的应用。
 缺点：计算一次乘法**需要8个周期**。速度**比较慢、时延大**。

2.流水线乘法器比串行乘法器的速度快很多很多，在非高速的信号处理中有广泛的应用。至于高速信号的乘法一般需要利用FPGA芯片中内嵌的硬核DSP单元来实现。

​		那么接下来我们来看有符号八位乘法器的实现。有符号数的乘法可以分为以下三种情况：

1) 都是无符号数
 2) 都是有符号数
 3) a是有符号数，b是无符号数

​		如果两者都是无符号数 那就直接用*号连接即可，如果两者都是有符号数，那也可以用 *号连接，用补码的方式计算。而如果一个是有符号数，一个是无符号数，直接运算时将有符号数当无符号数来运算，最后用$signed（）机制来解决。那么signed的修饰是为什么呢，是**为了区分有符号数和无符号数的加法和乘法吗？** 其实不是的，因为有符号数和无符号数据的加法强结果和乘法器结构是一样的，**signed的真正作用是决定如何对操作数扩位的问题**。

​		于是，我仿照文章中的代码，自己编写了一个简单的testbench来验证一下，并仿真出了波形。
![](https://github.com/lizejia2361/lizejia/blob/main/wave2.png)
由图中的数据可以看出，这个乘法器就实现了有符号数的乘法。如图所示，5*8=40（对应情况一，都是无符号数）， 10 * -3=-30（对应情况二，一个为无符号数，一个为有符号数），-20*-1=20（对应情况三，都是有符号数）。（ [Multply_Signed_Unsigned.v](代码\Multply_Signed_Unsigned.v)   ， [Multply_Signed_Unsigned_tb.vt](代码\Multply_Signed_Unsigned_tb.vt) ）

​		解决了问题一和问题二，最后就要来解决加速的问题了。经过摸索，以及学长的介绍，我了解到一个能够加速的乘法器，常常是应用了booth算法和wallace树结构。于是通过学校的VPN，在万方上找到了这么一篇关于实现16位有符号数加法器的论文并进行阅读学习。

​		采用改进的Booth算法，其优点在于可以将部分积的个数减半，从而有效地节约了部分积压缩器的时间延迟，提高乘法器的整体性能。 wallace树结构将全加器CSA组成树状的阵列，使多个加法并行执行，有效地减少了各级加法之间的等待延迟。（  [李_喻_2008_16×16快速乘法器的设计与实现.pdf](代码\李_喻_2008_16×16快速乘法器的设计与实现.pdf)  ）

​		之后我又在哔站上找到了一个32位快速乘法器的视频，详细学习了booth算法（【【IC设计】【前端到后端全流程】【基于Booth2算法的32位乘法器】3-Booth算法与Booth2算法讲解以及RTL设计】https://www.bilibili.com/video/BV1s84y1W72L?vd_source=59c53bb9449f5755f3333acdc359b185）

![](https://github.com/lizejia2361/lizejia/blob/main/booth1.jpg)

booth算法虽然化简为繁，但是却简化了运算（增加0的个数），由于二阶booth算法相较于一阶的更有优势，所以运用了二阶的booth算法
![](https://github.com/lizejia2361/lizejia/blob/main/booth2.jpg)

一阶booth算法每次编码只有两位，而二阶booth算法每次编码有三位，这使得部分积的数目只有一阶booth的一半。

​		用booth算法得出了部分积之后，就只需使用半加器和全加器将所有结果加起来即可。但是，为了让时间利用率提高，就使用了 wallace树结构来布置加法器，使得多个加法器可以并行运算，加快运算速度。

​		因此，模块需要有booth模块（处理部分积），半加器，全加器，Wallace树模块（进行部分积相加），顶层模块（赋值，将各个模块级联起来）之后就是照着视频，以及使用CSDN，百度，ChatGPT等搜索工具，完成模块设计和代码编写。

​		首先是booth编码器的编写，booth编码器的原理，简单理解就是把乘数中的每一个1看成“+2-1”。具体的数学原理及两位booth编码的实现逻辑如下：

![](https://github.com/lizejia2361/lizejia/blob/main/booth%E5%8E%9F%E7%90%86.png)

booth模块就相当于一个解码器，将16位的输入解码成32位的输出，并且通过信号控制来判断是否需要为结果加一的操作。即booth模块通过解码生成了32位的部分积用于后续操作。

 [booth_decoder.v](代码\homework-master\prj_mul_tc_16_16\src\booth_decoder.v)

![](https://github.com/lizejia2361/lizejia/blob/main/choose.png)

这就是一个 Booth 解码器模块，它将一个乘数 `xin` 和一个3位的控制信号 `yin` 转换成一个部分积 `xout`。另外，它也提供了一个 `cout` 信号，指示是否需要在结果上加1。

 // 对于控制信号 y 的各种情况，定义不同的情况

```verilog
wire x_add1 = (~yin[2] & ~yin[1] & yin[0]) | (~yin[2] & yin[1] & ~yin[0]);
// 当 y = 001 时，相当于 (not y[2]) and (not y[1]) and y[0]

wire x_add2 = (~yin[2] & yin[1] & yin[0]);
// 当 y = 010 时，相当于 (not y[2]) and y[1] and y[0]

wire x_sub2 = (yin[2] & ~yin[1] & ~yin[0]);
// 当 y = 100 时，相当于 y[2] and (not y[1]) and (not y[0])

wire x_sub1 = (yin[2] & ~yin[1] & yin[0]) | (yin[2] & yin[1] & ~yin[0]);
// 当 y = 101 时，相当于 y[2] and (not y[1]) and y[0] 或者 y[2] and y[1] and (not y[0])

// 根据不同的情况，选择对应的部分积
assign xout = {17{x_add1}} & {xin[15], xin} // 加法为正数，符号位为0
            | {17{x_add2}} & {xin[15:0], 1'b0}
            | {17{x_sub1}} & {~xin[15], ~xin}  // 减法需要进行"取反加一"操作
            | {17{x_sub2}} & ({~xin[15:0], 1'b1}) 
            ;
```
 [booth_decoder_8.v](代码\homework-master\prj_mul_tc_16_16\src\booth_decoder_8.v) 

```verilog
// 导入所需的模块
`include "booth_decoder.v"

module booth_decoder_8 (
    input  wire [15:0] xin       ,  // 输入：乘数 x
    input  wire [15:0] yin       ,  // 输入：乘数 y，依序取其3bit进行译码得到booth编码的选择信号
    output wire [7:0]  cout      ,  // 输出：是否"加一"
    output wire [31:0] xout0     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout1     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout2     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout3     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout4     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout5     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout6     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout7        // 输出：Booth编码后的部分积
);
```

这个模块则是通过调用解码器模块，根据y值的不同，选择相应子模块进行编码的合并，这样就可以将编码合并成32位的部分积。 

完成了booth算法对部分积和乘数的预处理，接下来就是Wallace树的实现。由于Wallace树模块需要用到半加器和全加器，所以先编写这两个工具，至于原理就不在多讲了。

 [half_adder.v](代码\homework-master\prj_mul_tc_16_16\src\half_adder.v)  [full_adder.v](代码\homework-master\prj_mul_tc_16_16\src\full_adder.v) 

之后将两个模块应用到Wallace树中。这里先说说Wallace压缩器（需要六个全加器和一个半加器）原理：

1.n个全加器每次把三个n位的数相加转换成两个数相加

2.因此,n个全加器每次可以把m个n位的数相加转换成2m/3个数相加再用一层全加器转换成4m/9个数相加直到转换成2个数;再用加法器把最后两个数相加。

这是一层的结构，总共有四层。原理如图：

![](https://github.com/lizejia2361/lizejia/blob/main/%E5%8E%8B%E7%BC%A9%E6%9C%BA.png)

[wallace_1_8.v](代码\homework-master\prj_mul_tc_16_16\src\wallace_1_8.v) 

这个模块就实现了一个Wallace树压缩器。它将n个1位数按照权重相加，产生和S和进位C，同时将进位传递到左侧。整个加法器以多层级的方式组织，每层级对应一个具体的加法器模块。（共四层）

```Verilog
 // layer 1
    wire [5: 0]    layer_2_in;// 第二层的输入
	 // 实例化第一层的各个加法器模块
    full_adder u_adder_l1_1(.cin(N[7-:3]),.Cout(cout[0]),.S(layer_2_in[5]));
    full_adder u_adder_l1_2(.cin(N[4-:3]),.Cout(cout[1]),.S(layer_2_in[4]));
    half_adder u_adder_l1_3(.cin(N[1-:2]),.Cout(cout[2]),.S(layer_2_in[3]));
	// 将进位传递到第二层的输入
    assign layer_2_in[2:0] = {cin[0],cin[1],cin[2]};
```

[wallace_32_8.v](代码\homework-master\prj_mul_tc_16_16\src\wallace_32_8.v) 

而这个文件就是对上个文件进行运用例化实现的可以将8个部分积相加，产生和S以及进位C的累加器

```Verilog
`include "wallace_1_8.v"
// 导入所需的模块，wallace树压缩器
module wallace_32_8(
    // input wire [31:0]  xin[7:0] ,//booth编码后得到的8个部分积
    input wire [31:0]  xin0     ,	// 输入：第0部分积
    input wire [31:0]  xin1     ,	// 输入：第1部分积
    input wire [31:0]  xin2     ,	// 输入：第2部分积
    input wire [31:0]  xin3     ,	// 输入：第3部分积
    input wire [31:0]  xin4     ,	// 输入：第4部分积
    input wire [31:0]  xin5     ,	// 输入：第5部分积
    input wire [31:0]  xin6     ,	// 输入：第6部分积
    input wire [31:0]  xin7     ,	// 输入：第7部分积
    input wire [5:0]   cin      ,//32位数的wallace树最右侧的cin
    output wire [31:0] C        ,//32位数的wallace树最上面的输出进位C
    output wire [31:0] S        ,//32位数的wallace树最上面的输出结果S
    output wire [5:0]  cout      //32位数的wallace树最左侧的cout，被丢弃了，没用
);
```



之后就是制作一个32位先行进位加法器，使得可以同时对多个数据进行加操作（块内并行和块间并行，同时处理多个进位）。
![](https://github.com/lizejia2361/lizejia/blob/main/32%E4%BD%8D%E5%85%88%E8%A1%8C%E8%BF%9B%E4%BD%8D%E5%8A%A0%E6%B3%95%E5%99%A8.png)

[adder32.v](代码\homework-master\prj_mul_tc_16_16\src\adder32.v) 

 [adder4.v](代码\homework-master\prj_mul_tc_16_16\src\adder4.v) 

最后就是编写顶层文件，以及testbench文件。 

  [mul_tc_16_16.v](代码\homework-master\prj_mul_tc_16_16\src\mul_tc_16_16.v) 

[mul_tc_16_16_tb.v](代码\homework-master\prj_mul_tc_16_16\src\mul_tc_16_16_tb.v) 

我还写了一个简单的16位有符号数乘法器进行结果的比对来验证结果的准确性。（ [mul_tc_16_16_ref.v](代码\homework-master\prj_mul_tc_16_16\src\mul_tc_16_16_ref.v) ）
结果：
！[](https://github.com/lizejia2361/lizejia/blob/main/final_wave.png)

