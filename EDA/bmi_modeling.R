library(tidyverse)
source('utils/bin_ucod.R')

df <- tar_read(new_linked_nhisV4)

df <- df %>% 
  mutate(
    BMI = if_else(BMI >= 1000 & BMI != 9999, BMI / 100, BMI))

bmi_df <- df %>% select(c("BMI", "UCOD_LEADING")) %>% filter(BMI < 95)

# Visualize the overlap ---------------------------------------------------

levels(bmi_df$UCOD_LEADING) <- c("HR", "NeoP", "LowerRes", 'Accident', "Cerebro", 'Alz', 'Diabetes', 'Flu', "Neph", "Other")

ggplot(bmi_df, aes(x = BMI, fill = UCOD_LEADING)) + 
  geom_density(alpha = 0.5) + theme_minimal()

bmi_df %>% filter(BMI > 30) %>% 
  ggplot(aes(x = BMI, fill = UCOD_LEADING)) +
  geom_density(alpha = .5)

bmi_df %>% filter(BMI < 30) %>% 
  ggplot(aes(x = BMI, fill = UCOD_LEADING)) +
  geom_density(alpha = .5)


# Visualize Overlap as binary ---------------------------------------------

bmi_df <- df %>% select(c("BMI", "UCOD_LEADING")) %>% filter(BMI < 95)

bmi_df <- bmi_df %>% mutate(UCOD_LEADING = if_else(
  UCOD_LEADING %in% c("001", "007"), 1, 0))

bmi_df$UCOD_LEADING <- factor(bmi_df$UCOD_LEADING, levels = c(1, 0))
levels(bmi_df$UCOD_LEADING) <- c("HrDib", "Other")

ggplot(bmi_df, aes(x = BMI, fill = UCOD_LEADING)) + 
  geom_density(alpha = 0.5) +theme_minimal()

bmi_df %>% filter(BMI > 30) %>% 
  ggplot(aes(x = BMI, fill = UCOD_LEADING)) +
  geom_density(alpha = .5)

bmi_df %>% filter(BMI < 30) %>% 
  ggplot(aes(x = BMI, fill = UCOD_LEADING)) +
  geom_density(alpha = .5)


# Compare BMI as category -------------------------------------------------

df <- df %>% filter(BMI < 95) %>% 
  mutate(BMI = case_when(
    BMI < 18.5 ~ "Underweight",
    BMI >= 18.5 & BMI < 25 ~ "Healthy Weight",
    BMI >=25 & BMI < 30 ~ "Overweight",
    BMI >= 30 ~ "Obese"
))

df <- bin_ucod(df)

ggplot(df, aes(x = BMI, fill = UCOD_LEADING)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(y = "Proportion", title = "Proportion of UCOD_LEADING within each BMI group")
