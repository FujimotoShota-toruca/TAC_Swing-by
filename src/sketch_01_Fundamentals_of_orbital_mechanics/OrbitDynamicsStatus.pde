// OrbitDynamicsStatusクラス:軌道力学の状態変数である位置及び速度を更新するクラス
class OrbitDynamicsStatus{
  PVector Position = new PVector(0,0); // 位置
  PVector Velocity = new PVector(0,0); // 速度
  PVector Acceleration = new PVector(0,0); // 加速度
  float Mass; // 質量
  
  // コンストラクタ
  OrbitDynamicsStatus(PVector _Position, PVector _Velocity, PVector _Mass){
    this.Position = _Position;
    this.Velocity = _Velocity;
    this.Mass = _Mass;
  }
  
  // 重力加速度の計算
  void GravitationalAcceleration(PVector OtherPosition, float OtherMass){
    // 発生する力の大きさの計算
    float GravitationForce, Distance;// 万有引力と距離を格納する変数
    Distance = this.Position.dist(OtherPosition); // 万有引力を計算する相手方の距離を算出
    GravitationForce = (OtherMass)/Distance // 万有引力により発生する加速度
    // 発生する力の方向の計算
    PVector acceleration;
    acceleration.set(OtherPosition.x-this.Position.x, OtherPosition.y-this.Position.y) // 相対位置ベクトルの計算
    acceleration.normalize(); // 単位ベクトルに
    // 力の方向と大きさの積で万有引力が計算できた
    this.Acceleration.set(acceleration.mult(GravitationForce))
  }

  // 速度・位置の更新関数
  void StateusUpdate(float dt){
    // 本当はRK4とかにしたほうがいいけどとりあえず放置
    PVector work;
    //加速度ベクトル～新速度,新位置確定
    work.set(this.Acceleration);//汎用ベクトル化.
    work.mult(dt);//速度の変化量を求める.
    this.Velocity.add(work);//新規速度=現在速度＋変化量.
    
    work.set(this.Velocity);//汎用ベクトル化.
    work.mult(dt);//変位を求める.
    this.Position.add(work);//新規位置=現在位置＋変位.
  }

}
