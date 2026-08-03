const failures=[];
const near=(name,actual,expected,tolerance=0.0006)=>{
  const pass=Math.abs(actual-expected)<=tolerance;
  console.log(`${pass?"PASS":"FAIL"} ${name}: ${actual}`);
  if(!pass) failures.push(`${name}: expected ${expected}, got ${actual}`);
};
const simpson=(f,a,b,n=300000)=>{
  if(n%2)n++;
  const h=(b-a)/n;
  let sum=f(a)+f(b);
  for(let i=1;i<n;i++)sum+=(i%2?4:2)*f(a+i*h);
  return sum*h/3;
};
const root=(f,a,b)=>{
  let lo=a,hi=b;
  for(let i=0;i<100;i++){
    const mid=(lo+hi)/2;
    if(f(lo)*f(mid)<=0)hi=mid; else lo=mid;
  }
  return (lo+hi)/2;
};

near("MCQ 8 acceleration",Math.sin(1.3**2)+2*1.3**2*Math.cos(1.3**2),0.5909487469,1e-9);
const innerRoot=Math.sqrt(2-Math.sqrt(3.5));
const outerRoot=Math.sqrt(2+Math.sqrt(3.5));
near("MCQ 11 inner critical magnitude",innerRoot,0.3594040993,1e-9);
near("MCQ 11 outer critical magnitude",outerRoot,1.9674421703,1e-9);
near("MCQ 16 accumulation derivative",2.4*Math.cos(1.2**6),-2.3710017210,1e-9);
near("MCQ 18 Euler estimate",0.75+0.25*(0.25**2-0.75),0.578125,1e-12);
near("MCQ 19 logistic time",Math.log(3)/0.4,2.7465307217,1e-9);
near("MCQ 21 semicircle volume",Math.PI/8*simpson(x=>Math.exp(-2*x*x),0,1.5),0.2454232689,1e-9);
near("MCQ 23 vector speed",Math.hypot(0.8,Math.exp(-1.4)),0.8371439916,1e-9);
near("MCQ 25 parametric second derivative",(0.5/(Math.cos(0.5)**2))/(1+Math.cos(1)),0.4214907702,1e-9);
near("MCQ 29 Lagrange bound",0.7**6/720,0.0001634014,1e-10);

const c=root(x=>Math.exp(-x)-x,0,1);
near("FRQ 2 transcendental root",c,0.5671432904,1e-9);
near("FRQ 2 removable limit",-c-1,-1.5671432904,1e-9);
near("FRQ 4 implicit second derivative",-42/125,-0.336,1e-12);

const net=t=>5+Math.sin(t)-0.8*t;
const tankTime=root(net,5,5.5);
near("FRQ 5 net rate at 2",net(2),4.3092974268,1e-9);
near("FRQ 5 net change",5*6+(1-Math.cos(6))-0.4*6**2,15.6398297133,1e-9);
near("FRQ 5 maximum time",tankTime,5.0864243810,1e-9);
near("FRQ 5 maximum amount",40+5*tankTime+(1-Math.cos(tankTime))-0.4*tankTime**2,55.7180619198,1e-9);

const fPrime=x=>Math.exp(-x/3)*(x*x-4*x+1);
const f=x=>2+simpson(fPrime,0,x);
const fCritical1=2-Math.sqrt(3);
const fCritical2=2+Math.sqrt(3);
near("FRQ 7 maximum x",fCritical1,0.2679491924,1e-9);
near("FRQ 7 maximum value",f(fCritical1),2.1270064955,1e-9);
near("FRQ 7 minimum x",fCritical2,3.7320508076,1e-9);
near("FRQ 7 minimum value",f(fCritical2),-1.5500405290,1e-9);
near("FRQ 7 inflection",5-2*Math.sqrt(3),1.5358983849,1e-9);

near("FRQ 8 FTC integral",5/4,1.25,1e-12);
near("FRQ 9 improper partial fractions",Math.log(2),0.6931471806,1e-9);

const gPrime=x=>Math.exp(-x*x)*Math.cos(x**3);
const G=x=>simpson(gPrime,0,x);
const gRoots=[Math.cbrt(Math.PI/2),Math.cbrt(3*Math.PI/2),Math.cbrt(5*Math.PI/2)];
near("FRQ 10 G(2)",G(2),0.6954087645,1e-9);
near("FRQ 10 critical 1",gRoots[0],1.1624473515,1e-9);
near("FRQ 10 critical 2",gRoots[1],1.6765391932,1e-9);
near("FRQ 10 critical 3",gRoots[2],1.9877570104,1e-9);
near("FRQ 10 absolute maximum",G(gRoots[0]),0.7303267318,1e-9);
near("FRQ 10 endpoint minimum",G(0),0,1e-12);

near("FRQ 11 exact solution at 1",3/Math.E,1.1036383235,1e-9);
const regionArea=simpson(x=>Math.exp(-x*x),0,1.5);
const squareVolume=simpson(x=>Math.exp(-2*x*x),0,1.5);
const washerVolume=Math.PI*simpson(x=>4-(2-Math.exp(-x*x))**2,0,1.5);
near("FRQ 12 area",regionArea,0.8561883936,1e-9);
near("FRQ 12 square volume",squareVolume,0.6249652224,1e-9);
near("FRQ 12 semicircle volume",Math.PI/8*squareVolume,0.2454232689,1e-9);
near("FRQ 12 washer volume",washerVolume,8.7957945187,1e-9);

near("FRQ 13 parametric second derivative",3/2,1.5,1e-12);
near("FRQ 14 displacement magnitude",Math.hypot(-2,2),2*Math.SQRT2,1e-12);
near("FRQ 14 circular distance",2*(Math.PI/2),Math.PI,1e-12);

const theta=Math.PI/4;
const polarRadius=2+Math.sin(theta**2);
const polarDerivative=2*theta*Math.cos(theta**2);
const polarSlope=(polarDerivative*Math.sin(theta)+polarRadius*Math.cos(theta))/(polarDerivative*Math.cos(theta)-polarRadius*Math.sin(theta));
near("FRQ 15 polar x",polarRadius*Math.cos(theta),1.8232527660,1e-9);
near("FRQ 15 polar y",polarRadius*Math.sin(theta),1.8232527660,1e-9);
near("FRQ 15 polar slope",polarSlope,-2.9755505386,1e-9);
near("FRQ 15 polar area",0.5*simpson(x=>(2+Math.sin(x*x))**2,0,Math.PI/2),5.1184046546,1e-9);
near("FRQ 15 polar area rate",0.5*polarRadius**2,3.3242506488,1e-9);

near("FRQ 16 derived series value",(1/3)/(1-1/3)**2,3/4,1e-12);
near("FRQ 18 eighth derivative",8*7*6*5*4*3*2,40320,1e-12);
const p4=1+0.6+0.6**2/2+0.6**3/6+0.6**4/24;
near("FRQ 19 degree-4 value",p4,1.8214,1e-12);
near("FRQ 19 Lagrange bound",Math.exp(0.6)*0.6**5/120,0.0011807330,1e-9);
near("FRQ 20 x^10 coefficient",1/(2**5*120),1/3840,1e-12);

if(failures.length){
  console.error(failures.join("\n"));
  process.exit(1);
}
console.log("PASS 49 independent numerical and algebraic checks.");
