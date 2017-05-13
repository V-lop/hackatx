Tree[] trees = new Tree[6];
boolean start = false;
Axe a = new Axe();


void setup()
{
  size(650,300);
  background(0,150,250);
  frameRate(1);
  
  noStroke();
  fill(0,170,70);
  rect(0,200,650,100);//ground
  
  for(int i = 0; i <= 5; i++)
  {
    trees[i] = new Tree(i*100+50,100);
    trees[i].display();
  }
  
  fill(255);
  textSize(24);
  text("Click anywhere in this box to start the game.", 50,225,550,275);
}

int sec = 0;
int kills = 5;
void draw()
{
  if(start)
  {
    sec++;
  
    if (sec%3 == 0)
    {
      if(trees[kills].inDanger())
        trees[kills].kill();
      if (kills >=0)
        kills--;
    } //end of killing trees loop
    
    boolean gameOver = true;
    
    for (int i = 0; i < 6; i++)
    {
      if (trees[i].inDanger() && trees[i].alive())
        gameOver = false;
    }
    
    if(gameOver)
    {
      noStroke();
      fill(0,170,70);
      rect(0,200,650,100); //redraw grass
      fill(255);
      textSize(24); //set up for text
      if(allSafe())
        text("You saved all the trees!", 50,225,550,275);
      else if(allDead())
        text("All the trees died.", 50,225,550,275);
      else
        text("You saved some trees.", 50,225,550,275);
        
      start = false; //don't keep playing
    }//end of game over loop
    
    a.move();
    a.display();
  } //end of if loop to only go when game has started
}//end of draw

void mousePressed()
{
  if(start == false)
  {
    start = true;
   
    fill(0,170,70);
    rect(0,200,650,100);//redraw ground
    fill(255);
    textSize(24);
    text("The trees are disappearing! Click on a tree to save it.", 50,225,550,275);
  }
  
  for (int i = 0; i < 6; i++)
  {
    if (trees[i].mouseNearTree())
    {
      trees[i].stopDanger();     
    }
  } //stop danger when you click a tree
}

boolean allSafe()
{
  for(int i = 0; i < 6; i++)
  {
    if(trees[i].inDanger())
      return false;
  }
  return true;
}

boolean allDead()
{
  for(int i = 0; i < 6; i++)
  {
    if(trees[i].alive())
      return false;
  }
  return true;
}

class Tree
{
  int xpos;
  int ypos;
  boolean alive;
  boolean danger;
  
  Tree(int x,int y)
  {
    xpos = x;
    ypos = y;
    alive = true;
    danger = true;
  }
  
  void display()
  {
    noStroke();
    
    fill(100,70,0);
    rect(xpos,ypos,30,100); //tree trunk
    
    fill(0,150,65);
    ellipse(xpos+15,ypos,75,75); //tree leaves
  }
  
  void kill()
  {
    noStroke();
    fill(0,150,250);
    rect(xpos-25,ypos-40,80,130);
    
    alive = false;
  }
  
  boolean alive()
  {
    return alive;
  }
  
  boolean inDanger()
  {
    return danger;
  }
  
  void stopDanger()
  {
    danger = false;
    
    fill(0);
    textSize(20);
    text("Saved!", xpos-15,ypos+7); //mark tree as safe
  }
  
  boolean mouseNearTree()
  {
    if (mouseX > xpos-25 && mouseX < xpos-25+80)
    {
      if(mouseY > ypos-37 && mouseY < ypos-37+137)
        return true;
    }
    return false;
  }
}

class Axe
{
  int xpos;
  int ypos;
  Axe()
  {
    xpos = 650;
    ypos = 140;
  }
  
  void display()
  {
    noStroke();
    fill(150);
    triangle(xpos,ypos+5,xpos-20,ypos-10,xpos-20,ypos+20); //blade
    
    stroke(100,70,0);
    strokeWeight(10);
    line(xpos,ypos,xpos,ypos+40);//handle
  }
  
  void move()
  {
    noStroke();
    fill(0,150,250);
    rect(xpos-30,ypos-12,40,60); //cover old axe
    
    for(int i=0; i<6; i++) //this loop redraws covered trees
    {
      if (trees[i].alive())
      {
        trees[i].display();
      } //redraw tree itself
      
      if (!trees[i].inDanger())
      {
        trees[i].stopDanger();
      } //remark as saved
    } //end of redrawing covered trees
    
    xpos -= 33; //reposition new axe
  }
}