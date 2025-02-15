
//Eath infomation
PVector Eath_p=new PVector(0,0);//位置
PVector Eath_v;//速度
PVector Eath_a;//重力加速度
PVector Eath_dp;//変位分
PVector Eath_dv;//変速分
PVector Eath_F;//力
float Eath_mass=10000000;

//satellite infomation
float stat_sat_prm = 0;
PVector satellite_p=new PVector(200,0);
PVector satellite_v=new PVector(0,stat_sat_prm);
PVector satellite_a=new PVector(0,0);
PVector satellite_dp=new PVector(0,0);
PVector satellite_dv=new PVector(0,0);
PVector satellite_da=new PVector(0,0);
PVector satellite_F=new PVector(0,0);
float satellite_mass=2;

float dt=0.1;//微小変化時間
float t=0.0;//経過時間
float f=0,a=0,v=0,d=0;
int cont=1;

void setup(){
  size(1500,1000);
    //fullScreen(P3D);
  frameRate(60/4);
  background(0);
  //println(Eath_p.x,Eath_p.y,Eath_p.z);
  //println(satellite_p.x,satellite_p.y,satellite_p.z);
  //println(Eath_p.dist(satellite_p));
}
void draw(){
  //background(0);
  translate(width/2,height/2);
  Eath();
  satellite();
  t+=0.1;
}


//Eath define
void Eath(){
  pushMatrix();
    translate(Eath_p.x,Eath_p.y);
    stroke(0,200,0);
    fill(0,0,255);
    ellipse(0,0,200,200);
  popMatrix();
}

//satellite define
void satellite(){
  pushMatrix();
    translate(satellite_p.x,satellite_p.y);
    stroke(0,2,0);
    fill(255,255,255);
    ellipse(0,0,10,10);
  popMatrix();
  
  satellite_p.normalize(satellite_F);//位置ベクトルの単位ベクトル生成　
  satellite_F.mult(Eath_mass/sq(Eath_p.dist(satellite_p)));//位置ベクトルの単位ベクトル＊|M/(satellite-Eath)^2|＝g
  satellite_da.x=-satellite_F.x;//各軸
  satellite_da.y=-satellite_F.y;//加速変分に
  satellite_a.set(satellite_da.x,satellite_da.y);//加速度に加速変分を追加
    
  satellite_dv.x=satellite_a.x*dt;
  satellite_dv.y=satellite_a.y*dt;
  satellite_v.add(satellite_dv.x,satellite_dv.y);
  
  satellite_dp.x=satellite_v.x*dt;
  satellite_dp.y=satellite_v.y*dt;
  satellite_p.add(satellite_dp.x,satellite_dp.y);

  println(stat_sat_prm+cont*10);
  
  if(sq(satellite_p.x)+sq(satellite_p.y)+sq(satellite_p.z)<sq(100) || sq(satellite_p.x)+sq(satellite_p.y)+sq(satellite_p.z)>sq(1000)){
    satellite_p=new PVector(200,0);
    satellite_v=new PVector(0,stat_sat_prm+cont*10);
    cont++;
    if(cont>10000) noLoop();
  }
}
