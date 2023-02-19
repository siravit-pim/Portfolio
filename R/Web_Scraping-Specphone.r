# Web Scraping
install.packages("tidyverse")
installed.packages("rvest")
library(tidyverse)
library(rvest) # scrap data from internet

# Specphone
phone = read_html("https://specphone.com/Realme-10-Pro-.html#specification")

phone1 = phone %>%
  html_nodes("div.topic") %>%
  html_text2()
phone2 = phone %>%
  html_nodes("div.detail") %>%
  html_text2()

df1 = data_frame(phone1, phone2)
View(df1)

# all Xiaomi
url = read_html("https://specphone.com/brand/Xiaomi")

link = url %>%
  html_nodes("li.mobile-brand-item a") %>%
  html_attr("href")

links = paste0("https://specphone.com",link)
## ---------------------------------
result = data.frame()
for (link in links[1:10]) {
  
  title = link %>%
    read_html() %>%
      html_node("h1.page-topic") %>%
      html_text2()
  
  att = link %>%
    read_html() %>%
            html_nodes("div.topic") %>%
            html_text2()
  
    detail = link %>%
      read_html() %>%        
            html_nodes("div.detail") %>%
            html_text2()
    
    tmp = data.frame(title, att, detail)
    result = bind_rows(result, tmp)
    print("progress...")
}
head(result)
