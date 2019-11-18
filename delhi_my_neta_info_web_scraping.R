library(data.table)
library(rvest)
library(stringi)
library(stringr)
library(openxlsx)

details_df = data.frame(Name = character(), ContactNumber = character(), 
                Email =character(), Age = character(), Relation = character(),Education = character(), 
                Profession= character(), Address = character(), Party = character(),Location = character())

i <- sprintf("%03d", 1:763)  
url <- paste("http://myneta.info/delhi2015/candidate.php?candidate_id=", i, sep = "")

for(i in seq_along(url)){
  print(i)
  read1 <- read_html(url[i])
  
  name <- read1 %>%
    html_node('.main-title , .grid_2 , b')%>%
    html_text()
  
  location <- read1 %>%
    html_node('h5 , .grid_3~ .alpha+ .alpha , .alpha:nth-child(5)')%>%
    html_text()
  location <- substring(location, regexpr(":", location) + 1)
  
  party <- read1 %>%
    html_node('h5+ .alpha')%>%
    html_text()
  party <- substring(party, regexpr(":", party) + 1)
  
  education <- read1 %>%
    html_node('.left-margin')%>%
    html_text()
  
  profession <- read1 %>%
    html_node('p , .left-margin')%>%
    html_text()
  profession  <- substr(x = profession,start = 18,stop = 74)
  
  address <- read1 %>%
    html_node('.alpha:nth-child(6)')%>%
    html_text()
  address <-substring(address, regexpr(":", address) + 1)
  
  txt2 <- read1 %>%
    html_nodes(".grid_3~ .alpha+ .alpha , .alpha:nth-child(5)")%>%
    html_text()
  
  contactNum <- txt2[2]
  contactNum <- substring(contactNum, regexpr(":", contactNum) + 1)
  print(contactNum)
  age<- txt2[1]
  age <- substring(age, regexpr(":", age) + 1)
  
  txt <- read1 %>%
    html_nodes(".grid_2")%>%
    html_text()
  email <- txt[5]
  email <- substring(email, regexpr(":", email) + 1)
  
  relation<- txt[2]
  relation <- substring(relation, regexpr(":", relation) + 1)
  
  df = data.frame(Name = character(), ContactNumber = character(), 
                  Email =character(), Age = character(), Relation = character(),Education = character(), 
                  Profession= character(), Address = character(), Party = character(),Location = character())
  
  df = data.frame(Name = name, Location = location, Party=party, Relation= relation, Age = age,Address = address, 
                  Email=email, ContactNumber= contactNum, Profession = profession,
                  Education= education)
  
   
  details_df = rbind(details_df,df)  
  
}


View(details_df)

setwd("C:/Users/user/Desktop/R")


write.xlsx(details_df, file = "delhi_myneta_info.xlsx")
