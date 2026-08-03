const failures=[];
const near=(name,actual,expected,tolerance=0.0006)=>{
  const pass=Math.abs(actual-expected)<=tolerance;
  console.log(`${pass?"PASS":"FAIL"} ${name}: ${actual}`);
  if(!pass) failures.push(`${name}: expected ${expected}, got ${actual}`);
};
const simpson=(f,a,b,n=200000)=>{
  if(n%2)n++;
  const h=(b-a)/n;
  let sum=f(a)+f(b);
  for(let i=1;i<n;i++)sum+=(i%2?4:2)*f(a+i*h);
  return sum*h/3;
};
const roots=(f,a,b,step=0.0005)=>{
  const found=[];
  let x=a,y=f(x);
  for(let z=a+step;z<=b+1e-12;z+=step){
    const next=f(z);
    if(y===0||y*next<0){
      let lo=x,hi=z;
      for(let i=0;i<60;i++){
        const mid=(lo+hi)/2;
        if(f(lo)*f(mid)<=0)hi=mid; else lo=mid;
      }
      found.push((lo+hi)/2);
    }
    x=z;y=next;
  }
  return found;
};

near("MCQ 11 velocity",3*2.35**2-9.4*2.35+2.1,-3.4225,1e-9);
near("MCQ 12 area rate",2*Math.PI*5.2*0.37,12.0888485,1e-6);
near("MCQ 20 right sum",0.7*2.8+1.2*1.6+1.1*3.4,7.62,1e-9);
near("MCQ 24 average value",simpson(x=>Math.exp(-x*x),0,1.6)/1.6,0.5407914,1e-6);
near("MCQ 28 disk volume",Math.PI*simpson(x=>Math.exp(-2*x*x),0,1.3),1.9503483,1e-6);
near("MCQ 29 displacement",simpson(t=>Math.sin(t*t)+0.5,0,2.2),1.7192285,1e-6);
near("MCQ 30 arc length",simpson(x=>Math.sqrt(1+4*x*x),0,1.4),2.5195568,1e-6);

const net=t=>12+3*Math.sin(t*t/8)-(4+0.5*t*t);
near("FRQ 1 rate at 2",net(2),7.4382766,1e-6);
near("FRQ 1 net change",simpson(net,0,6),17.9181097,1e-6);
near("FRQ 1 maximum time",roots(net,0,6)[0],4.4433361,1e-6);
near("FRQ 1 maximum amount",80+simpson(net,0,roots(net,0,6)[0]),107.9533653,1e-6);

const velocity=t=>t**3-5*t*t+4*t+1;
const velocityRoots=roots(velocity,0,5);
near("FRQ 2 first direction change",velocityRoots[0],1.2864621,1e-6);
near("FRQ 2 second direction change",velocityRoots[1],3.9122292,1e-6);
near("FRQ 2 displacement",simpson(velocity,0,5),35/12,1e-8);
const distance=Math.abs(simpson(velocity,0,velocityRoots[0]))+Math.abs(simpson(velocity,velocityRoots[0],velocityRoots[1]))+Math.abs(simpson(velocity,velocityRoots[1],5));
near("FRQ 2 total distance",distance,19.8016560,1e-6);

const fp=x=>Math.exp(-x/2)*(x*x-5*x+3);
const f=x=>2+simpson(fp,0,x);
const critical=roots(fp,0,6);
near("FRQ 3 local maximum x",critical[0],0.6972244,1e-6);
near("FRQ 3 local maximum value",f(critical[0]),2.8866026,1e-6);
near("FRQ 3 local minimum x",critical[1],4.3027756,1e-6);
near("FRQ 3 local minimum value",f(critical[1]),0.4612097,1e-6);
near("FRQ 3 inflection",roots(x=>Math.exp(-x/2)*(-0.5*x*x+4.5*x-6.5),0,6)[0],1.8074176,1e-6);

const gp=t=>Math.sqrt(1+t**4);
const g=x=>simpson(gp,0,x);
near("FRQ 4 g(1)",g(1),1.0894294,1e-6);
near("FRQ 4 g(2)",g(2),3.6534845,1e-6);
near("FRQ 4 g(x)=3",roots(x=>g(x)-3,0,2)[0],1.8280399,1e-6);

const population=t=>500/(1+5.25*Math.exp(-0.3*t));
near("FRQ 5 P(10)",population(10),396.3905913,1e-6);
near("FRQ 5 P'(10)",0.3*population(10)*(1-population(10)/500),24.6418769,1e-6);
near("FRQ 5 maximum-growth time",Math.log(5.25)/0.3,5.5274269,1e-6);

const intersection=4**(2/3);
near("FRQ 6 intersection",intersection,2.5198421,1e-6);
near("FRQ 6 area",simpson(x=>Math.sqrt(x)-x*x/4,0,intersection),4/3,1e-6);
near("FRQ 6 revolution volume",Math.PI*simpson(x=>x-x**4/16,0,intersection),5.9843610,1e-6);
near("FRQ 6 square-section volume",simpson(x=>(Math.sqrt(x)-x*x/4)**2,0,intersection),0.8163777,1e-6);

const trans=x=>x*Math.exp(-x*x/4);
near("FRQ 7 maximum value",trans(Math.SQRT2),0.8577639,1e-6);
const halfRoots=roots(x=>trans(x)-0.5,0,5);
near("FRQ 7 first half-value",halfRoots[0],0.5374409,1e-6);
near("FRQ 7 second half-value",halfRoots[1],2.5540891,1e-6);
near("FRQ 7 average value",simpson(trans,0,5)/5,0.3992278,1e-6);

const cut=(17-Math.sqrt(79))/3;
near("FRQ 16 optimal cut",cut,2.7039352,1e-6);
near("FRQ 16 maximum volume",cut*(20-2*cut)*(14-2*cut),339.0125508,1e-6);

if(failures.length){
  console.error(failures.join("\n"));
  process.exit(1);
}
console.log("PASS 36 independent numerical and algebraic checks.");
