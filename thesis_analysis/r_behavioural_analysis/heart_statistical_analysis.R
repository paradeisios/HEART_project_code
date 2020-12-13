
library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggpubr)
library(gridGraphics)
library(lme4)
library(sjPlot)
library(jtools)
library(buildmer)
########################################### BASIC EDA ###########################################################

df <- read.csv('C:\\Users\\User\\Documents\\Academia\\Thesis\\Methods\\Behaviour\\dataframes\\heart.csv')
df_dprime <- read.csv('C:\\Users\\User\\Documents\\Academia\\Thesis\\Methods\\Behaviour\\dataframes\\dprime.csv')
df_reaction_time <- read.csv('C:\\Users\\User\\Documents\\Academia\\Thesis\\Methods\\Behaviour\\dataframes\\reaction.csv')

df$Condition<- factor(df$Condition)
df$Response<-factor(df$Response)
df$Corrects<-factor(df$Corrects)
df_reaction_time$Condition<- factor(df_reaction_time$Condition)
df_reaction_time$Response<-factor(df_reaction_time$Response)
df_reaction_time$PerceiverZero<-factor(df_reaction_time$PerceiverZero)
df_reaction_time$PerceiverHalf<-factor(df_reaction_time$PerceiverHalf)
df_reaction_time$PerceiverUQuart<-factor(df_reaction_time$PerceiverUQuart)
df_reaction_time$PerceiverLQuart<-factor(df_reaction_time$PerceiverLQuart)

df <- na.omit(df)
df_reaction_time <- na.omit(df_reaction_time)
attach(df)


df%>%
  mutate(Condition=recode(Condition,
                          '1'= 'sync',
                          '2'= 'async'),
         Response=recode(Response,
                         '1'= 'mine',
                         '2'= 'other'),
         Corrects= recode(Corrects,
                           '1' = 'Correct',
                           '0' = 'Wrong')) -> df


df_reaction_time%>%
  mutate(Condition=recode(Condition,
                          '1'= 'sync',
                          '2'= 'async'),
         Response=recode(Response,
                         '1'= 'mine',
                         '2'= 'other'),
         PerceiverZero= recode(PerceiverZero,
                          '1' = 'Good',
                          '0' = 'Bad'),
         PerceiverHalf= recode(PerceiverHalf,
                           '1' = 'Good',
                           '0' = 'Bad'),
         PerceiverUQuart= recode(PerceiverUQuart,
                               '1' = 'Good',
                               '0' = 'Bad'),
         PerceiverLQuart= recode(PerceiverLQuart,
                                 '1' = 'Good',
                                 '0' = 'Bad')) -> df_reaction_time

df_sync <- df %>%
  filter(Condition == 'sync')
df_async <- df %>%
  filter(Condition == 'async')


##### Explore Reaction Time

hist_all <- ggplot(df, aes(x=Reaction_Time)) + geom_histogram(color="black", fill="white")
hist_sync <- ggplot(df_sync, aes(x=Reaction_Time)) + geom_histogram(color="black", fill="white")
hist_async <- ggplot(df_async, aes(x=Reaction_Time)) + geom_histogram(color="black", fill="white")

box_all <- ggplot(df, aes(x=Condition, y=Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))+
  ylab("Reaction Time")
box_sync <- ggplot(df_sync, aes(x=Condition, y=Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))
box_async <- ggplot(df_async, aes(x=Condition, y=Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))

ggarrange(hist_sync, hist_sync, hist_async,box_all,box_sync,box_async, ncol = 3, nrow = 2, labels = c("All", "Sync", "Async"))

shapiro.test(Reaction_Time)
###### There are too many outliers - Next step is to explore z scores to see how many are above sd 3

df <- df%>%
  mutate(z_Reaction_Time = scale(Reaction_Time)) %>%
  filter(z_Reaction_Time < 3 )%>%
  filter(z_Reaction_Time > - 3)

hist(df_below_3$Reaction_Time)
attach(df)
###### Check Log Transformation to correct for heavy positive skewness

df_log <- df %>%
  mutate(Log_Reaction_Time = log10(Reaction_Time))

df_log <- df_log[-c(465,58,436),]
df_log_sync <- df_log %>%
  filter(Condition == 'sync')
df_log_async <- df_log %>%
  filter(Condition == 'async')

  
log_hist_all <- ggplot(df_log, aes(x=Log_Reaction_Time)) + geom_histogram(color="black", fill="white")
log_hist_sync <- ggplot(df_log_sync, aes(x=Log_Reaction_Time)) + geom_histogram(color="black", fill="white")
log_hist_async <- ggplot(df_log_async, aes(x=Log_Reaction_Time)) + geom_histogram(color="black", fill="white")

log_box_all <- ggplot(df_log, aes(x=Condition, y=Log_Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))
log_box_sync <- ggplot(df_log_sync, aes(x=Condition, y=Log_Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))
log_box_async <- ggplot(df_log_async, aes(x=Condition, y=Log_Reaction_Time, fill = Response)) + 
  geom_boxplot(position=position_dodge(1))

ggarrange(log_hist_sync,log_hist_sync, log_hist_async,log_box_all,log_box_sync,log_box_async, ncol = 3, nrow = 2, labels = c("Log All", "Log Sync", "Log Async"))

shapiro.test(df_log$Log_Reaction_Time)

###################################################################################################
############################ CHECK REACTION TIMES #################################################
###################################################################################################

buildmer(Reaction_Time ~  Condition +  PerceiverUQuart + (1|Response) , data = df_reaction_time)  

buildmer(Reaction_Time ~  Corrects  + (1|Response) + (1 | Subject), data = df)


###################################################################################################
############################ CHECK CORRECT RESPONSES ##############################################
###################################################################################################


attach(df)

tbl1 <- table(Condition,Response)
tbl2 <- table(Condition,Corrects)

chi <- chisq.test(tbl)

df_correct_summ <- df_count %>% group_by(Subject,Condition,Response) %>% summarize(mean = mean(n),sd = sd(n))

p<- ggplot(df_correct_summ, aes(x=Condition, y=mean, fill=Response)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9))




model <- glm(data = df, Corrects~Condition , family= binomial)

###################################################################################################
############################### MEDIAN REACTION TIME ##############################################
###################################################################################################

library(psycho)

df_reaction_median <- df %>% 
  group_by(Subject,Condition,Response)%>%
  summarise(Reaction_Time = median(Reaction_Time))

#Manually make df_prime in excel, that contains n_hit,n_miss,n_fa,n_corr_rejections
#Manually calculate dprime values for each subject based on the psycho::dprime function

df_dprime<-df_dprime %>%
  mutate(accuracy = (n_hits + n_corr) /(n_hits + n_miss + n_fa + n_corr))
df_dprime<-df_dprime %>%
  mutate(performance = (n_hits + n_corr) /(n_miss + n_fa))

#Manually classify subjects on the reaction_time csv file 

ggboxplot(df_reaction_median, x = "Condition", y = "Reaction_Time", color = "Response",
          palette = c("#00AFBB", "#E7B800"))

model_zero <- aov(Reaction_Time ~ Condition * Response* PerceiverZero,data= df_reaction_time)
model_lowq <- aov(Reaction_Time ~ Condition * Response* PerceiverLQuart,data= df_reaction_time)
model_half <- aov(Reaction_Time_median ~ Condition * Response* PerceiverHalf,data= df_reaction_time)
model_uppq <- aov(Reaction_Time ~ Condition * Response* PerceiverUQuart,data= df_reaction_time)


summary(model_zero)
summary(model_lowq)
summary(model_half)
summary(model_uppq)

buildmer(Reaction_Time_median ~  Condition +  accuracy + Response , data = df_reaction_time)  

df_reaction_time %>%
  filter(PerceiverUQuart == 'Bad')%>%
  summarise(mean = mean(Reaction_Time_median),
            sd = sd(Reaction_Time_median))
#### The post false reaction time is performed on Python


df %>%
  group_by(Subject)%>%
  filter(Subject == 's1')%>%
  table(Condition,Response)
