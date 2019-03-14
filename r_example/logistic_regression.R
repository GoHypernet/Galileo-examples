#```{r}
#Read in the data
d1 <- read.csv("./Market_Research.csv")

#convert variables to factors
d1$Age <- factor(d1$Age, levels = c(1,2,3,4,5,6),labels = c("<20", "20-24", "25-29", "30-34", "35-39", "40+"))

d1$Income <- factor(d1$Income, levels = c(1,2,3,4,5,6),labels = c("<50k", "50-75k", "75-100k", "100-125k", "125-150", "150+"))

d1$Educ <- factor(d1$Educ, levels = c(1,2,3,4,5),labels = c("HS, GED, or Less", "Some College", "Associate's Degree", "Bachelor's Degree", "Graduate Degree"))

d1$Race <- factor(d1$Race, levels = c(1,2,3,4,5),labels = c("Black", "White", "Hispanic", "Asian", "Other"))

d1$SafeInv <- factor(d1$SafeInv, levels = c(1,2,3,4),labels = c("BTC", "ETH", "Homes", "Dollars"))

d1$InvAss <- factor(d1$InvAss, levels = c(1,2,3,4),labels = c("BTC", "DOOR", "TETHER", "ETH"))

d1$MillLikert <- factor(d1$MillLikert, levels = c(1,2,3),labels = c("Gen Z", "Millenials", "40+"))

#DOOR1 + DOOR2 + Age + MillLikert + MillDummy + Male + Educ + Income + Race + InvCrypto + SafeInv + InvFut + InvAss + LikICO

model <- glm(DOOR2 ~ Age + Male + Educ, family=binomial(link='logit'), data=d1)
summary(model)

#```
