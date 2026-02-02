############################################################
# PROJECT: ADVANCED SALES PERFORMANCE & REVENUE ANALYSIS
# DOMAIN: ELECTRIC VEHICLE SALES
# ROLE: BUSINESS ANALYTICS / DATA SCIENCE
############################################################

# ===============================
# 1. LOAD LIBRARIES
# ===============================
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(forecast)
library(randomForest)
library(cluster)
library(factoextra)
library(corrplot)
library(survival)
library(igraph)

set.seed(123)

# ===============================
# 2. LOAD DATA
# ===============================
ev_sales <- read.csv("Electric vehicle sales .csv", stringsAsFactors = FALSE)

# ===============================
# 3. DATA CLEANING
# ===============================
ev_sales$Date <- parse_date_time(ev_sales$Date,
                                 orders = c("ymd","dmy","mdy","my","ym"))
ev_sales <- ev_sales %>% filter(!is.na(Date))

ev_sales <- ev_sales %>%
  mutate(
    Year = year(Date),
    Month = month(Date, label = TRUE)
  )

# ===============================
# 4. DESCRIPTIVE STATISTICS
# ===============================
summary(ev_sales[, c("Units_Sold","Revenue")])
sd(ev_sales$Revenue)
var(ev_sales$Revenue)

# ===============================
# 5. DESCRIPTIVE VISUALIZATIONS
# ===============================
ggplot(ev_sales, aes(Revenue)) +
  geom_histogram(bins = 30, fill = "steelblue") +
  labs(title = "Revenue Distribution")

ggplot(ev_sales, aes(Units_Sold, Revenue)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm") +
  labs(title = "Units Sold vs Revenue")

# ===============================
# 6. CUMULATIVE FREQUENCY
# ===============================
ev_sales %>%
  arrange(Revenue) %>%
  mutate(CumRevenue = cumsum(Revenue)) %>%
  ggplot(aes(seq_along(CumRevenue), CumRevenue)) +
  geom_line() +
  labs(title = "Cumulative Revenue Curve")

# ===============================
# 7. CHI-SQUARE TEST
# ===============================
sales_cat <- cut(ev_sales$Units_Sold, breaks = 3,
                 labels = c("Low","Medium","High"))
chisq.test(table(ev_sales$Region, sales_cat))

# ===============================
# 8. ONE-WAY ANOVA
# ===============================
anova_model <- aov(Revenue ~ Region, data = ev_sales)
summary(anova_model)

# ===============================
# 9. LINEAR REGRESSION
# ===============================
lm_model <- lm(Revenue ~ Units_Sold + Region, data = ev_sales)
summary(lm_model)

# ===============================
# 10. LOGISTIC REGRESSION
# ===============================
ev_sales$High_Revenue <- ifelse(
  ev_sales$Revenue > median(ev_sales$Revenue), 1, 0)

logit_model <- glm(
  High_Revenue ~ Units_Sold + Region,
  data = ev_sales,
  family = "binomial"
)
summary(logit_model)

# ===============================
# 11. RANDOM FOREST (PREDICTIVE MODEL)
# ===============================
rf_model <- randomForest(
  Revenue ~ Units_Sold + Region,
  data = ev_sales,
  ntree = 200,
  importance = TRUE
)
varImpPlot(rf_model)

# ===============================
# 12. BINOMIAL DISTRIBUTION
# ===============================
success_prob <- mean(ev_sales$High_Revenue)
dbinom(0:10, size = 10, prob = success_prob)

# ===============================
# 13. CORRELATION HEATMAP
# ===============================
num_data <- ev_sales %>%
  select(Units_Sold, Revenue)
corrplot(cor(num_data), method = "color")

# ===============================
# 14. ARIMA FORECASTING
# ===============================
ts_revenue <- ts(ev_sales %>%
                   group_by(Date) %>%
                   summarise(Revenue = sum(Revenue)) %>%
                   pull(Revenue),
                 frequency = 12)

arima_model <- auto.arima(ts_revenue)
plot(forecast(arima_model, h = 6))

# ===============================
# 15. MONTE CARLO SIMULATION
# ===============================
mc_sim <- replicate(1000,
                    sum(rnorm(12,
                              mean(ev_sales$Revenue),
                              sd(ev_sales$Revenue))))
hist(mc_sim, main = "Monte Carlo Revenue Simulation")

# ===============================
# 16. SENTIMENT ANALYSIS (SIMULATED)
# ===============================
ev_sales$Sentiment <- sample(c("Positive","Neutral","Negative"),
                             nrow(ev_sales), replace = TRUE)

ggplot(ev_sales, aes(Sentiment)) +
  geom_bar(fill = "purple") +
  labs(title = "Customer Sentiment Distribution")

# ===============================
# 17. CUSTOMER CLUSTERING
# ===============================
clust_data <- scale(ev_sales[, c("Units_Sold","Revenue")])
kmeans_model <- kmeans(clust_data, centers = 3)
fviz_cluster(kmeans_model, data = clust_data)

# ===============================
# 18. SURVIVAL ANALYSIS (CLV PROXY)
# ===============================
ev_sales$Time <- as.numeric(ev_sales$Date - min(ev_sales$Date))
ev_sales$Event <- ifelse(ev_sales$Units_Sold == 0, 1, 0)

surv_model <- survfit(Surv(Time, Event) ~ 1, data = ev_sales)
plot(surv_model, main = "Customer Lifetime Survival Curve")

# ===============================
# 19. BAYESIAN A/B TESTING (SIMPLIFIED)
# ===============================
group_A <- rbinom(100, 1, 0.45)
group_B <- rbinom(100, 1, 0.55)

mean(group_A)
mean(group_B)

# ===============================
# 20. WHAT-IF SCENARIO ANALYSIS
# ===============================
what_if_units <- ev_sales$Units_Sold * 1.10
predicted_revenue <- predict(lm_model,
                             newdata = data.frame(
                               Units_Sold = what_if_units,
                               Region = ev_sales$Region
                             ))

mean(predicted_revenue)

# ===============================
# 21. NETWORK ANALYSIS (REGION LINKS)
# ===============================
edges <- ev_sales %>%
  count(Region) %>%
  select(from = Region, to = Region)

graph <- graph_from_data_frame(edges)
plot(graph, main = "EV Sales Network by Region")

############################################################
# END OF MASTER SCRIPT
############################################################
