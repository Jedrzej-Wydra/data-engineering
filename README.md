# Organizing and processing data from thermovision photos.

#### authors: Jędrzej Wydra

## History
This project is actually a subproject of a larger study, which you can find here. The main researchers were conducting experiments on the heat generation of larvae on corpses—yes, you read that right, larvae on corpses. This fascinating work produced hundreds of thermovision photos. My task? Well, it sounded simple enough at first: extract the average temperature of the “meat” from each image.

But as with any good forensic drama, there were some plot twists. After some back-and-forth about which files I could actually receive, I ended up with a collection that included a thermovision jpg, a thermovision png, a regular jpg photo, and an Excel file full of mysterious data that looked like it was encrypted by some ancient code. The only thing I could definitively decode was that the minimum and maximum temperatures from the images matched those in the Excel file.

So, in short, my job was to turn a bunch of photos into neat tables of numbers. And guess what? I did it.

## Disclaimer
Unfortunately, I can’t share all of the data used in this project, but I’m providing a small sample of the files I received. As for the R scripts, you might notice that some of the file path structures look a bit unusual — this is due to the internal data management policies we had to follow during the project and anonymization.
