PrintWriter file; 
float x, y;

int LABIT_status=0;
int T_flag = 0;
float dt = 0.1;
final float w=1600/2;
final float h= 900/2;

Planet earth, moon;
Artificial probe;

void setup(){
  // 現在の時刻を取得
  String timestamp = nf(year(), 4) + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "_" + nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
  
  // 時刻を含むファイル名を作成
  String filename = "orbit_data_" + timestamp + ".csv";
  
  file = createWriter(filename);
  background(0);
  size(1600, 900);
  frameRate(60);
  start_screen();
}

void draw(){
  orbitPhese();
}

// 月の計算を実施
class Planet{//メンバ
  public PVector a = new PVector(0,0);//加速度ベクトル.
  public PVector V = new PVector(0,0);//速度ベクトル.
  public PVector P = new PVector(0,0);//位置ベクトル.
  public float radius;//半径.
  public float mass;//質量.
  
  PVector work = new PVector(0,0);//汎用ベクトル.
  
  
    Planet(float Px, float Py, float Vx, float Vy, float R, float M){
      //コンストラクタ
      this.P.set(Px,Py);//初期位置決定.
      this.V.set(Vx,Vy);//初期速度決定.
      this.radius=R;//半径決定.
      this.mass=M;//質量決定.
    }
      //メゾット
        //描画関数系
      void Point(int R, int G, int B){//点表示.
        stroke(R, G, B);//引数により色決定
        strokeWeight(5);
        point(this.P.x, this.P.y);//点の座標決定.
      }
      void Ellipse(int R, int G, int B){//円表示.
        fill(R, G, B);//引数により色決定
        stroke(R, G, B);
        ellipse(this.P.x , this.P.y, this.radius*2,this.radius*2);
      }//円の座標,大きさ決定
      
       //計算系
      void Acc(PVector a_p, float a_mass){
        //万有引力の法則と運動方程式～加速度算出.
        float F,dist_p;//計算用変数
        dist_p=this.P.dist(a_p);//相手の星との距離計算.
        F=(a_mass)/sq(dist_p);//発生する加速度.
        work.set(a_p.x-this.P.x, a_p.y-this.P.y);//発生する力の向き.
        work.normalize();//向きの単位化.
        a.set(work);
        a.mult(F);//加速度ベクトル確定.
      }
      void New(){
        //加速度ベクトル～新速度,新位置確定
        work.set(this.a);//汎用ベクトル化.
        work.mult(dt);//速度の変化量を求める.
        this.V.add(work);//新規速度=現在速度＋変化量.
        
        work.set(this.V);//汎用ベクトル化.
        work.mult(dt);//変位を求める.
        this.P.add(work);//新規位置=現在位置＋変位.
      }
}

// 探査機の計算を実施
class Artificial extends Planet{//クラスの継承.
  
  public float u_fuel=1;//Use.噴射質量.
  public float v_fuel=50;//Velocity.噴射速度.
  public float fuel;//燃料
  float delta_V;

  Artificial(float Px, float Py, float Vx, float Vy, float R, float M, float F){
    super(Px, Py, Vx, Vy, R, M);//スーパークラス
    this.fuel=F;//初期燃料規定
  }
   void Acc(PVector one_P, PVector more_P, float one_m, float more_m){
         //加速度のオーバーライド
        float F,dist_p;//計算用変数
        dist_p=this.P.dist(one_P);//相手の星その①との距離計算
        F=(one_m)/sq(dist_p);//発生する加速度1の大きさ
        work.set(one_P.x-this.P.x, one_P.y-this.P.y);//向き
        work.normalize();//正規化
        work.mult(F);
        a.set(work);//惑星その①との間にかかる加速度確定
        
        dist_p=this.P.dist(more_P);//相手の星その②との距離計算
        F=(more_m)/sq(dist_p);//発生する加速度2の大きさ
        work.set(more_P.x-this.P.x, more_P.y-this.P.y);//向き
        work.normalize();//単位化
        work.mult(F);//加速度確定
        a.add(work);//加速度(①＋②)によりこれに働く正式な加速度を求めた
   }
   void thrustar(){
     if(this.fuel>0){
     if(keyPressed==true){//何かキーが押された時
       float b_fuel = this.fuel;//燃料残量保持
       this.fuel = this.fuel - u_fuel;//燃料残量更新
       float delta_V = this.u_fuel/( this.mass + b_fuel );//燃料の相対速度,質量比算出 
       work.set(this.V);//速度ベクトルを取得
       work.normalize();//正規化(単位ベクトル化)
       work.mult(v_fuel*delta_V);//速度の比をかけた。
         if(keyCode==UP){
           this.V.add(work);//UPなら接線速度増加
           T_flag=1;
         }
         if(keyCode==DOWN){
           this.V.sub(work);//dawnなら接線速度減少
           T_flag=-1;
         }
     }
   }
   }
}

// 軌道計算のセットアップ(初期条件)
void start_screen() {
  earth = new Planet(60+w, 0+h, 0, -0.1375, 10, 80000);
  moon = new Planet(550+w, 0+h, 0, 11.5, 5, 1000); 
  //probe = new Artificial(0+w, 0+h, 0, -40, 1, 100, 1000);// 月の周りを周回させたいときにコメントアウト
  //probe = new Artificial(580+w, 0+h, 0, 11+5, 5, 1000, 1000);// 月の周りを周回させたいときにコメントアウト解除
  
  probe = new Artificial(560 + w, 10 + h, 10, 10, 5, 1000, 1000);// 月周回
  //probe = new Artificial(650 + w, 100 + h, -5, 10, 5, 1000, 1000);// !減速スイングバイ
  //probe = new Artificial(600 + w, 100 + h, -1, 10, 5, 1000, 1000); // !加速スイングバイ
 }

// 軌道計算全体を実施
int orbitPhese() {
  rectMode(CORNER);
  int RABIT=0;//続行
  fill(0, 30, 50, 10);
  rect(0, 0, width, height);

  textAlign(CORNER);
  fill(255);
  textSize(25);
  text("[Key Guide]", 40, 60);
  text("SPEED UP  :↑", 70, 95);
  text("SPEED DOWN:↓", 70, 130);
  text("RESTART   :R", 70, 165);
  text("BACK MENU :E", 70, 200);

  earth.Acc(moon.P, moon.mass);
  moon.Acc(earth.P, earth.mass);
  probe.Acc(earth.P, moon.P, earth.mass, moon.mass);

  //probe.thrustar(); // ここを有効化するとゲームにできる

  earth.New();
  moon.New();
  probe.New();
  
  strokeWeight(5);

  earth.Ellipse(0, 200, 200);
  moon.Ellipse(255, 255, 200); 
  probe.Ellipse(255, 0, 255);
  
  csv_loging(earth.P);
  csv_loging(moon.P);
  csv_loging(probe.P);
  csv_loging(probe.V);
  file.println(T_flag);
  T_flag=0;
    
  return RABIT;
}

void csv_loging(PVector V){
  file.print(V.x);
  file.print(",");
  file.print(V.y);
  file.print(",");
  file.print(V.z);
  file.print(",");
}

void keyReleased() 
{
    if (keyCode == 'E'){
      file.flush();
      file.close();
      exit();
    }
    if (keyCode == 'R'){
       background(0);
       start_screen();
    }
} 
