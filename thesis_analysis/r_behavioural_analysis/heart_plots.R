ggplot(data = df_reaction_time)+
  geom_boxplot(aes(x=Reaction_Time_median,y = Condition, color = Response))+
  xlab('Reaction Time  (s)')


ggplot(data = df_reaction,(aes(x=accuracy,y = Reaction_Time)))+
  geom_smooth(method='lm')+
  geom_point()+
  ylab('Reaction Time  (s)')+
  xlab('Accuracy')


ggplot(df_dprime, aes(y=Reaction, x= accuracy)) +
  geom_smooth(method = 'lm')

line<- ggline(df_reaction_time, x = "Condition", y = "Reaction_Time", 
       add = c("mean_se"),
       color = "Response", palette = "jco")
ggline(
  df_reaction, x = "Condition", y = "Reaction_Time", add = "mean_se",
  color = "Response",  shape = "Response",
  palette = "jco", ylab = 'Reaction Time (s)'
) 

line3 <- ggline(
  df_reaction_time, x = "Condition", y = "Reaction_Time_median", add = "mean_se",
  color = "Response",  shape = "Response",
  palette = "jco", facet.by = "PerceiverHalf"
) 
line <- ggline(
  df_reaction_time, x = "Condition", y = "Reaction_Time", add = "mean_se",
  color = "Response",  shape = "Response",
  palette = "jco", facet.by = "PerceiverLQuart"
) 
line <- ggline(
  df_reaction_time, x = "Condition", y = "Reaction_Time_median", add = "mean_se",
  color = "Response",  shape = "Response",
  palette = "jco", facet.by = "PerceiverUQuart",ylab = 'Reaction Time (s)'
) 

ggarrange(box,line, ncol = 1, nrow = 2)

7




box <- ggboxplot(df_reaction_time,
          y = "Reaction_Time_median",
          x = "Condition",
          color = "Response",
          facet.by = "PerceiverUQuart",
          ylab = 'Reaction Time (s)')