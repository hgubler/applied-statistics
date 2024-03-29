library(lme4)
load("Project-4/Data/bootstrap_data.RData")
# create full model
mixed_m1 = lmer(dvote ~ . 
                - evotes 
                - region 
                - state_ideology 
                - ideology_comp 
                - year
                + (1|year:region)
                + (1|year), 
                REML = FALSE,
                data = data)
# create model without random intercept for year
mixed_m0 = lmer(dvote ~ . 
                - evotes 
                - region 
                - state_ideology 
                - ideology_comp 
                - year
                + (1|year:region), 
                REML = FALSE,
                data = data)
n = 1000 # number of bootstraps
#calculate likelihood ratio statistic
lrstat = as.numeric(2*(logLik(mixed_m1)-logLik(mixed_m0))) 
lrstats = rep(0,n) # to store the bootstrapped results
set.seed(1) # for reproducability
for(i in 1:n) {
  # create bootstrap dataset with simulated response
  data_boot = data
  data_boot$dvote = unlist(simulate(mixed_m0))
  # fit models with simulated response
  mixed_m0_boot = lmer(dvote ~ . 
                       - evotes 
                       - region 
                       - state_ideology 
                       - ideology_comp 
                       - year
                       + (1|year:region), 
                       REML = FALSE,
                       data = data_boot)  
  mixed_m1_boot = lmer(dvote ~ . 
                       - evotes 
                       - region 
                       - state_ideology 
                       - ideology_comp 
                       - year
                       + (1|year:region)
                       + (1|year), 
                       REML = FALSE,
                       data = data_boot)  
  # calculate likelihood ratio statistic
  lrstats[i] = as.numeric(2*(logLik(mixed_m1_boot)-logLik(mixed_m0_boot)))
}
# estimate p-value
p = mean(lrstats > lrstat)
print(p)
