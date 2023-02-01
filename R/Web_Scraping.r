# Web Scraping
install.packages("tidyverse")
installed.packages("rvest")
library(tidyverse)
library(rvest) # scrap data from internet

# IMBD  - Movie
url = "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"
imdb = read_html(url)

titles = imdb %>%
  html_nodes("h3.lister-item-header") %>%
    html_text2()

ratings = imdb %>%
  html_nodes("div.ratings-imdb-rating") %>%
  html_text2() %>%
  as.numeric()
# ratings[1:10]

vote = imdb %>%
  html_nodes("p.sort-num_votes-visible") %>%
  html_text2()

df = data.frame(
  titles,
  ratings,
  vote
)
head(df) # View(df)

## ---------------------------------
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
