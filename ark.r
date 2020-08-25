daily <- function(){
  
  download.file("https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_INNOVATION_ETF_ARKK_HOLDINGS.csv", destfile = "ARK_INNOVATION_ETF_ARKK_HOLDINGS.csv")
  download.file("https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS.csv", destfile = "ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS.csv")
  download.file("https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS.csv", destfile = "ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS.csv")
  download.file("https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS.csv", destfile = "ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS.csv")
  download.file("https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS.csv", destfile = "ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS.csv")
  
  Sys.sleep(0.1)
  dfK <- read.csv(file="ARK_INNOVATION_ETF_ARKK_HOLDINGS.csv", header = T)
  dfW <- read.csv(file="ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS.csv", header = T)
  dfG <- read.csv(file="ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS.csv", header = T)
  dfF <- read.csv(file="ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS.csv", header = T)
  dfQ <- read.csv(file="ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS.csv", header = T)
  
  dfK <- dfK[is.na(dfK$weight...)==F,]
  dfW <- dfW[is.na(dfW$weight...)==F,]
  dfG <- dfG[is.na(dfG$weight...)==F,]
  dfF <- dfF[is.na(dfF$weight...)==F,]
  dfQ <- dfQ[is.na(dfQ$weight...)==F,]
  
  #at least 2%
  dfK <- dfK[dfK$weight...>=1,]
  dfW <- dfW[dfW$weight...>=1,]
  dfG <- dfG[dfG$weight...>=1,]
  dfF <- dfF[dfF$weight...>=1,]
  dfQ <- dfQ[dfQ$weight...>=1,]
  
  df <- rbind(dfK, dfW, dfG, dfF, dfQ)
  
  
  df$ticker <- as.character(df$ticker)
  df$cusip <- as.character(df$cusip)
  df$ticker[df$ticker=="TREE UW"] <- "TREE"
  df$ticker[df$ticker=="ARCT UQ"] <- "ARCT"
  df$ticker[df$ticker=="ADYEN"] <- "ADYEY"
  df$ticker[df$ticker=="3690"] <- "MPNGF"
  df$ticker[df$cusip=="87238U203"] <- "TCS"
  
  freqs <- table(df$ticker)
  df <- aggregate(weight... ~ ticker, data=df, mean)
  df$freqs <- freqs 
  df$weight_multiple <- df$weight... * df$freqs
  df$weight_sqrtmultiple <- df$weight... * sqrt(df$freqs)
  df$date <- rep(dfK$date[1], times = nrow(df))
  add <- quantmod::getQuote(df$ticker, what = c("marketCap", "regularMarketPreviousClose"))
  df <- cbind(df, add[,-1])
  
  
  #no FAANG
  df <- df[df$ticker!="AAPL",]
  df <- df[df$ticker!="AMZN",]
  df <- df[df$ticker!="GOOGL",]
  df <- df[df$ticker!="GOOG",]
  df <- df[df$ticker!="FB",]
  df <- df[df$ticker!="MSFT",]
  df <- df[is.na(df$ticker)==F,]
  
  #remove low avg weight (below 3)
  df <- df[order(df$weight..., decreasing = T),]
  
  
  return(df)
}

setwd("C:/Users/q7/Desktop/i")
df <- daily()
head(df)

write.table(df, file = paste0("output/ark_", gsub("/", "_", df$date[1]),".csv"), row.names = F)

#check for new tickers
old_tickers <- read.table("tickers.csv", sep=";", header = T)
if (length(df$ticker[(df$ticker %in% old_tickers$ticker) == F])==0) {
  print("Nothing New!")
} else {
  print("New Tickers!")
  print(df$ticker[(df$ticker %in% old_tickers$ticker) == F])
}

#modiy by hand and print if needed
fix(old_tickers)
old_tickers$ticker <- as.character(old_tickers$ticker)
write.table(old_tickers, "tickers.csv", sep=";", row.names = F)

#include info on availability
#df_all$available <- NA
for (i in 1:length(df$ticker)) {
  df$available[i] <- old_tickers$available[old_tickers$ticker == df$ticker[i]]  
}
table(df$available)
df_a <- df[df$available==1,]

#weight
df_a$prop <- df_a$weight_sqrtmultiple/sum(df_a$weight_sqrtmultiple)
df_a <- df_a[order(df_a$prop, decreasing = T),]
pie(df_a$prop, labels = df_a$ticker)

#reweight


df_b <- df_a[1:20,]
df_b$prop <- df_b$prop/sum(df_b$prop)
pie(df_b$prop, labels = df_b$ticker)


sum(round(df_b$prop*100))
View(cbind(as.character(df_b$ticker), round(df_b$prop*100)))


df_b$growth_factor <- NA
df_b$growth_factor[df_b$ticker=="TSLA"] <- "electric revolution, mobility, autonomy"
df_b$growth_factor[df_b$ticker=="SQ"] <- "financial revolution"
df_b$growth_factor[df_b$ticker=="NVTA"] <- ""
df_b$growth_factor[df_b$ticker=="CRSP"] <- ""
df_b$growth_factor[df_b$ticker=="TWOU"] <- ""
df_b$growth_factor[df_b$ticker=="ROKU"] <- ""
df_b$growth_factor[df_b$ticker=="Z"] <- ""
df_b$growth_factor[df_b$ticker=="XLNX"] <- ""
df_b$growth_factor[df_b$ticker=="ILMN"] <- ""
df_b$growth_factor[df_b$ticker=="MELI"] <- ""
df_b$growth_factor[df_b$ticker=="SPLK"] <- ""
df_b$growth_factor[df_b$ticker=="EDIT"] <- ""
df_b$growth_factor[df_b$ticker=="SSYS"] <- "3d printing"
df_b$growth_factor[df_b$ticker=="SE"] <- ""
df_b$growth_factor[df_b$ticker=="ADYEY"] <- "fintech"
df_b$growth_factor[df_b$ticker=="PINS"] <- ""
df_b$growth_factor[df_b$ticker=="BABA"] <- ""
df_b$growth_factor[df_b$ticker=="SNAP"] <- ""
df_b$growth_factor[df_b$ticker=="TER"] <- ""
df_b$growth_factor[df_b$ticker=="FLIR"] <- ""
df_b$growth_factor[df_b$ticker=="JD"] <- ""
df_b$growth_factor[df_b$ticker=="FB"] <- ""
df_b$growth_factor[df_b$ticker=="PYPL"] <- ""
df_b$growth_factor[df_b$ticker=="SPOT"] <- ""
df_b$growth_factor[df_b$ticker=="CAT"] <- ""


