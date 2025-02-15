import processing.opengl.*;

// Earth information
PVector Eath_p = new PVector(0, 0, 0); // 位置
float Eath_mass = 10000000;

// Satellite information
float stat_sat_prm = 0;
PVector satellite_p = new PVector(200, 0, 0);
PVector satellite_v = new PVector(0, 0, stat_sat_prm);
PVector satellite_a = new PVector(0, 0, 0);
PVector satellite_dp = new PVector(0, 0, 0);
PVector satellite_dv = new PVector(0, 0, 0);
PVector satellite_da = new PVector(0, 0, 0);
PVector satellite_F = new PVector(0, 0, 0);
float satellite_mass = 2;

// 前回の衛星の位置を保存
PVector prev_satellite_p = satellite_p.copy();

float dt = 0.1; // 微小変化時間
float t = 0.0;  // 経過時間
int cont = 1;
int flag = 0;

void setup() {
  size(1500, 1000, OPENGL);
  frameRate(60);
  background(0);
}

void draw() {
  translate(width / 2, height / 2, 0);
  rotateX(radians(-90));
  Eath();
  satellite();
  t += 0.1;
}

// Earth描画
void Eath() {
  pushMatrix();
  translate(Eath_p.x, Eath_p.y, Eath_p.z);
  stroke(0, 200, 0);
  fill(0, 0, 255);
  sphere(100);
  popMatrix();
}

// 衛星の軌道計算と描画
void satellite() {
  flag++;

  // 衛星の軌道を線で描画（前回の位置と現在の位置を結ぶ）
  stroke(0, 255, 0); // 黄色の線
  line(
        prev_satellite_p.x, prev_satellite_p.y, prev_satellite_p.z, 
        satellite_p.x, satellite_p.y, satellite_p.z
      );

  // 現在の衛星位置を描画
  pushMatrix();
  translate(satellite_p.x, satellite_p.y, satellite_p.z);
  rotateY(t);
  stroke(0, 200, 0);
  fill(0, 0, 255);
  sphere(1);
  popMatrix();

  // 衛星の運動計算
  prev_satellite_p.set(satellite_p); // 前回の位置を保存

  satellite_p.normalize(satellite_F);
  satellite_F.mult(Eath_mass / sq(Eath_p.dist(satellite_p)));
  satellite_da.set(-satellite_F.x, -satellite_F.y, -satellite_F.z);
  satellite_a.set(satellite_da);

  satellite_dv.set(satellite_a.x * dt, satellite_a.y * dt, satellite_a.z * dt);
  satellite_v.add(satellite_dv);

  satellite_dp.set(satellite_v.x * dt, satellite_v.y * dt, satellite_v.z * dt);
  satellite_p.add(satellite_dp);

  if(flag > 200){ 
    satellite_p.set(1100, 0, 0); // 1000の外に飛ばす
  }

  // 軌道外に出たら初期化
  if (sq(satellite_p.x) + sq(satellite_p.y) + sq(satellite_p.z) < sq(100) ||
      sq(satellite_p.x) + sq(satellite_p.y) + sq(satellite_p.z) > sq(1000)) {
    satellite_p.set(200, 0, 0);
    prev_satellite_p.set(satellite_p);
    satellite_v.set(0, 0, stat_sat_prm + cont * 30);
    cont++;
    flag = 0;
    if (cont > 10000) noLoop();
  }
}
