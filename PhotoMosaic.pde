PImage img;
PImage _img;

PImage[] images;
float[] brightness;
PImage[] brightImages;

int scale = 2;
int w,h;

void setup(){
  size(1024,1024);
  img = loadImage("./images/Londra.jpg");
  File[] files = listFiles(sketchPath("images"));
  images = new PImage[files.length-1];
  brightness = new float[images.length];
  brightImages = new PImage[256];
  
  for(int i=0;i<images.length;i++){
    String filename = files[i].toString();
    PImage image = loadImage(filename);
    
    images[i] = createImage(scale,scale,RGB);
    images[i].copy(image,0,0,image.width,image.height,0,0,scale,scale);
    images[i].loadPixels();
    float avg = 0;
    for(int j=0;j<images[i].pixels.length;j++){
      float b = brightness(images[i].pixels[j]);
      avg += b;
    }
    avg /= images[i].pixels.length;
    brightness[i] = avg;
  }
  
  for(int i=0; i<brightImages.length;i++){
    float record = 256;
    for (int j = 0; j < brightness.length; j++){
      float diff = abs(i - brightness[j]);
      if (diff < record) {
        record = diff;
        brightImages[i] = images[j];
      }
    }
  }
  
  w = img.width/scale;
  h = img.height/scale;
  _img = createImage(w,h,RGB);
  _img.copy(img,0,0,img.width,img.height,0,0,w,h);
}

void draw(){
  background(0);
  _img.loadPixels();
  for(int x=0;x<w;x++){
    for(int y=0;y<h;y++){
      int index = x+y*w;
      color c = _img.pixels[index];
      int imageIndex = int(brightness(c));
      image(brightImages[imageIndex],x*scale,y*scale,scale,scale);
    }
  }

  noLoop();
}

File[] listFiles(String dir){
  File file = new File(dir);
  if(file.isDirectory()){
    File[] files = file.listFiles();
    return files;
  }
  else {
    return null;
  }
}