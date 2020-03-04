while (Sys.time() <= "2020-03-03 23:59:59 EST") {
  nyt_write("Alabama")
  nyt_write("Arkansas")
  nyt_write("California")
  nyt_write("Colorado")
  nyt_write("Maine")
  nyt_write("Massachusetts")
  nyt_write("Minnesota")
  nyt_write("North Carolina")
  nyt_write("Oklahoma")
  nyt_write("Tennessee")
  nyt_write("Texas")
  nyt_write("Utah")
  nyt_write("Vermont")
  nyt_write("Virginia")

  system("git add .")
  system("git commit -m 'super tuesday'")
  system("say 'Time to push!'")

  Sys.sleep(600)
}

