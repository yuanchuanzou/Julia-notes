## initilize
rm(list=ls()) #clean up
library(ggplot2)
## define functions
## ??factorת????ֵ??????ֵ?Ļ????ӵ����???warnings
as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

#setwd("C:/Users/zou/Dropbox/Work/2017SLSN14/SNIc") #only for windows
setwd("/Users/yuanchuan/Dropbox (个人)/Work/2017SLSN14/SNIc") #only for mac
SNIc <- read.csv("SN-Ic.csv")
SNIc <- subset(SNIc, type!="IIb")  # ȥ??IIb???͵?????
SNIc <- subset(SNIc, type!="IIbn")
SNIc <- subset(SNIc, type!="Ib")
SNIc$D <- log10(SNIc$D)
sn <- SNIc
n.row <- nrow(sn)
n.colum <- ncol(sn)
## change them into numeric

for (i.col in 3:n.colum){ # ??factorת????ֵ
  if (is.factor(sn[, i.col])){
    sn[, i.col] <- as.numeric.factor(sn[, i.col])
  }  
}

## plot
p <- ggplot(data=sn,aes(x=D, y=MpV, label=type))
p <- p + geom_point(aes(colour=type,shape=type),size=5)
p <- p + geom_errorbar(aes(ymin=MpV-eMpV, ymax=MpV+eMpV,colour=type,shape=type), width=.05,
              position=position_dodge(0.01))
#p <- p + geom_point(aes(x=D, y=MB),size=5,color="red", label=Name) # ??һ??????
p <- p + scale_y_reverse()  # ????y??
p <- p + theme_bw(base_size = 16)
p <- p + xlab("log10(D) (Mpc)")
p <- p + theme(legend.position=c(0.15, 0.8))
p <- p + theme(legend.text=element_text(size=16))
p <- p + theme(axis.text.x = element_text(size=16), axis.text.y = element_text(size=16))
#p <- p + theme(axis.title.x = element_text())

#p <- p + geom_text() # ????ÿ??SN??????

print(p)
ggsave(file="Miller-dia.pdf") 

#plot hisogram
# M=4.77-2.5log(L/Lsun), => logL=0.4(4.77-M)+logLsun=0.4(4.77-M)+33.59
p <- ggplot(data=sn,aes(x=(0.4*(4.77-MpV)+33.59)+6.2, label=type, colour=type)) 
p <- p + geom_histogram()

print(p)

## for peak magnitude
MpSNIc <- subset(SNIc, type=="Ic")$MpV #set the numbers #only for normal SNe Ic
#MpSNIc <- subset(SNIc, type==("Ic","GRB"...)$MpV #set the numbers #for all SNe Ic
MpSNIc <- as.numeric(levels(MpSNIc))[MpSNIc] #convert factor to vector
MpSNIc <- MpSNIc[!is.na(MpSNIc)] #get rid of "NA"
MpSNIc <- MpSNIc-1
MpGRB <- subset(SNIc, type=="GRB")$MpV
MpGRB <- as.numeric(levels(MpGRB))[MpGRB]
MpGRB <- MpGRB[!is.na(MpGRB)] #magnitude of the SN, not GRB jets or afterglow, here

ks.test(MpSNIc,MpGRB)

## plot ks.test, ref: https://rpubs.com/mharris/KSplot
sample1 <- MpSNIc
sample2 <- MpGRB
group <- c(rep("SNIc", length(sample1)), rep("GRB", length(sample2)))
dat <- data.frame(KSD = c(sample1,sample2), group = group)
# create ECDF of data
cdf1 <- ecdf(sample1) 
cdf2 <- ecdf(sample2) 
# find min and max statistics to draw line between points of greatest distance
minMax <- seq(min(sample1, sample2), max(sample1, sample2), length.out=length(sample1)) 
x0 <- minMax[which( abs(cdf1(minMax) - cdf2(minMax)) == max(abs(cdf1(minMax) - cdf2(minMax))) )] 
y0 <- cdf1(x0) 
y1 <- cdf2(x0) 
p <- ggplot(dat, aes(x = KSD, group = group, color = group))+
  stat_ecdf(size=1) +
  theme_bw(base_size = 16) +
  theme(legend.position =c(0.15, 0.8)) +
  xlab("peak magnitude") +
  ylab("cumulative fraction") +
  #geom_line(size=1) +
  geom_segment(aes(x = x0[1], y = y0[1], xend = x0[1], yend = y1[1]),
               linetype = "dashed", color = "red") +
  geom_point(aes(x = x0[1] , y= y0[1]), color="red", size=1) +
  geom_point(aes(x = x0[1] , y= y1[1]), color="red", size=1) +
  #ggtitle("K-S Test") +
  theme(legend.title=element_blank())
print(p)
ggsave(file="ks-ecdf-GRB-SN-SNmag.pdf") 

#### energy
EkSNIc <- subset(SNIc, type=="Ic")$MpV #set the numbers
EkSNIc <- as.numeric(levels(EkSNIc))[EkSNIc] #convert factor to vector
EkSNIc <- EkSNIc[!is.na(EkSNIc)] #get rid of "NA"
EkSNIc <-(0.4*(4.77-EkSNIc)+33.59)+6.2+3.3 #convert absolute mag to energy (10^6.2=20 days, peak time)
GRB <- read.csv("GRB-table-data.csv")
GRB <- GRB$E_iso
GRB <- as.numeric(levels(GRB))[GRB] #convert factor to vector
GRB <- GRB[!is.na(GRB)] #get rid of "NA"
EkGRB <- log10(GRB)+52 #E_gamma_iso

ks.test(EkSNIc,EkGRB)

## plot ks.test
sample1 <- EkSNIc
sample2 <- EkGRB
group <- c(rep("SNIc", length(sample1)), rep("GRB", length(sample2)))
dat <- data.frame(KSD = c(sample1,sample2), group = group)
# create ECDF of data
cdf1 <- ecdf(sample1) 
cdf2 <- ecdf(sample2) 
# find min and max statistics to draw line between points of greatest distance
minMax <- seq(min(sample1, sample2), max(sample1, sample2), length.out=length(sample1)) 
x0 <- minMax[which( abs(cdf1(minMax) - cdf2(minMax)) == max(abs(cdf1(minMax) - cdf2(minMax))) )] 
y0 <- cdf1(x0) 
y1 <- cdf2(x0) 
p <- ggplot(dat, aes(x = KSD, group = group, color = group))+
  stat_ecdf(size=1) +
  theme_bw(base_size = 16) +
  theme(legend.position ="top") +
  xlab("energy") +
  ylab("ECDF") +
  #geom_line(size=1) +
  geom_segment(aes(x = x0[1], y = y0[1], xend = x0[1], yend = y1[1]),
               linetype = "dashed", color = "red") +
  geom_point(aes(x = x0[1] , y= y0[1]), color="red", size=1) +
  geom_point(aes(x = x0[1] , y= y1[1]), color="red", size=1) +
  #ggtitle("K-S Test") +
  theme(legend.title=element_blank())
print(p)
ggsave(file="ks-ecdf-GRB-SN-Energy.pdf") 

#### energy
SLSN <- subset(SNIc, type=="SLSN-Ic")$MpV #set the numbers
SLSN <- as.numeric(levels(SLSN))[SLSN] #convert factor to vector
SLSN <- SLSN[!is.na(SLSN)] #get rid of "NA"
SLSN <-(0.4*(4.77-SLSN)+33.59)+6.2+2.3 #convert absolute mag to energy (10^6.2=20 days, peak time)
#EkGRB <- log10(GRB)+52 #E_gamma_iso, is from above

ks.test(SLSN,EkGRB)

## plot ks.test
sample1 <- SLSN
sample2 <- EkGRB
group <- c(rep("SLSN-Ic", length(sample1)), rep("GRB", length(sample2)))
dat <- data.frame(KSD = c(sample1,sample2), group = group)
# create ECDF of data
cdf1 <- ecdf(sample1) 
cdf2 <- ecdf(sample2) 
# find min and max statistics to draw line between points of greatest distance
minMax <- seq(min(sample1, sample2), max(sample1, sample2), length.out=length(sample1)) 
x0 <- minMax[which( abs(cdf1(minMax) - cdf2(minMax)) == max(abs(cdf1(minMax) - cdf2(minMax))) )] 
y0 <- cdf1(x0) 
y1 <- cdf2(x0) 
p <- ggplot(dat, aes(x = KSD, group = group, color = group))+
  stat_ecdf(size=1) +
  theme_bw(base_size = 16) +
  theme(legend.position ="top") +
  xlab("energy") +
  ylab("ECDF") +
  #geom_line(size=1) +
  geom_segment(aes(x = x0[1], y = y0[1], xend = x0[1], yend = y1[1]),
               linetype = "dashed", color = "red") +
  geom_point(aes(x = x0[1] , y= y0[1]), color="red", size=1) +
  geom_point(aes(x = x0[1] , y= y1[1]), color="red", size=1) +
  #ggtitle("K-S Test") +
  theme(legend.title=element_blank())
print(p)
ggsave(file="ks-ecdf-GRB-SLSN-Energy.pdf") 

## tips put here
#SNIc$D <- sample(1:100,dim(SNIc)[1]) # ??ֵ??????
#SNIc <- subset(SNIc, type!="IIb")  # ȥ??IIb???͵????ݣ?????type??.csv?ļ??и????ĵ???