
//Earth infomation
PVector Earth_p=new PVector(0,0);//位置
PVector Earth_v=new PVector(0,0);//速度
float Earth_mass=10000;

// 地球のインスタンスを作成
OrbitDynamicsStatus Earth;

//satellite infomation
float stat_sat_prm = 0;
PVector sat_p=new PVector(200,0);
PVector sat_v=new PVector(0,stat_sat_prm);
float sat_mass=2;

// 衛星のインスタンスを作成
OrbitDynamicsStatus sat;

float t = 0;
float dt=0.1;//微小変化時間
int cont=1;

void setup(){
  size(1500,1000);
  frameRate(60);
  background(0);
  Earth = new OrbitDynamicsStatus(Earth_p, Earth_v, Earth_mass);
  sat = new OrbitDynamicsStatus(sat_p, sat_v, sat_mass);
}

void draw(){
  //background(0);
  translate(width/2,height/2);
  Earth_fun();
  satellite_fun();
  t+=0.01;
}

//Earth define
void Earth_fun(){
  pushMatrix();
    translate(0, 0);
    stroke(0,200,0);
    fill(0,0,255);
    ellipse(0,0,200,200);
  popMatrix();
}

//satellite define
void satellite_fun(){

  // インスタンスの更新
  sat.GravitationalAcceleration(Earth.Position, Earth.Mass);
  sat.StatusUpdate(dt);

  float spx = sat.Position.x;
  float spy = sat.Position.y;

  // 描画
  pushMatrix();
    translate(spx, spy);
    stroke(255,255,255);
    fill(255,255,255);
    ellipse(0,0,10,10);
  popMatrix();
  
  if(sq(spx)+sq(spy)<sq(100) || sq(spx)+sq(spy)>sq(1000)){
    sat_p=new PVector(200,0);
    sat_v=new PVector(0,stat_sat_prm+cont*10);
    sat = new OrbitDynamicsStatus(sat_p, sat_v, sat_mass);
    cont++;
    if(cont>10000) noLoop();
    print(cont);
  }

}
//*/