
library(dplyr)
library(randomForest)
library("RODBC")
library(openxlsx)
#�������������� � ��
dbconnection <- odbcDriverConnect("Driver=ODBC Driver 11 for SQL Server;Server=vm-bi; Database=RTS_DWH_223;Uid=; Pwd=; trusted_connection=yes")
Fact_Data <- sqlQuery(dbconnection,paste("select * from [bi2].[BI_Analytics].[dbo].[Forecasting_44FZ_Fact_for_modeling];"))
str(Fact_Data)
dop_cal<- sqlQuery(dbconnection,paste("select * from [bi2].[BI_Analytics].[dbo].[Forecasting_44FZ_Fact_for_modeling_Cal_to_end_2018];"))
#������� �������������
train_data<-subset(Fact_Data,DocPublishDate<=as.Date("2017-12-31"))
model_rf<-randomForest(data=train_data,Procedure_Count~Sum_Range_order+IS_MSP_Purchase+MonthNumber+DayNumberOfWeek+WeekNumber,ntree=500,mtry=3)
test_data$yhat_rf <-predict(model_rf,test_data)
#sum((y - yhat_rf)^2,na.rm = TRUE)
write.xlsx(test_data, "RandomForest.xlsx", col_names = TRUE)