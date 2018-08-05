# ID3-Stripper
Strips ID3 data from music files.


Back when I was trying to make my music files more organized, I ran into a problem with the names of the artists/bands/song names in the metadata of the files. The corrupted metadata made every song have some weird looking title made of Chinese or Cyrillic characters, because the bytes were slightly off from the original titles. It really bugged me, so I wrote this program to repair all of the files. 

When I figured out that they were all corrupted in completely different ways, I just wrote one program to strip all of the metadata off of all of the files so that the music player on my phone would default to using the file's name as the music title.
