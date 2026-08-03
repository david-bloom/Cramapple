const failures=[];
const near=(name,actual,expected,tolerance=0.005)=>{if(Math.abs(actual-expected)>tolerance)failures.push(`${name}: expected ${expected}, got ${actual}`);};
const equal=(name,actual,expected)=>{if(actual!==expected)failures.push(`${name}: expected ${expected}, got ${actual}`);};

const cubic=x=>0.42*x**3-1.8*x**2+0.65*x+7.1;
near("MCQ cubic predicted change",cubic(3.1)-cubic(2.4),0.23);
const quartic=x=>x**4-6*x**2+2;
near("MCQ quartic average rate",(quartic(2.7)-quartic(1.2))/1.5,10.6,0.05);
near("MCQ culture prediction",480*(1260/480)**(8/5),2248,0.5);
near("MCQ logarithmic regression",Math.exp((12-4.8)/2.3),22.9,0.05);
near("MCQ sinusoidal value",18+7*Math.sin(7*Math.PI/12),24.8,0.05);
near("MCQ polar average rate",((3+Math.sin(2.2))-(3+Math.sin(0.8)))/0.7,0.13);

const f=x=>0.5*x**3-2*x**2-x+6;
near("FRQ function average rate",(f(4)-f(1))/3,-0.5);
for (const root of [1-Math.sqrt(7),2,1+Math.sqrt(7)]) near(`FRQ function root ${root}`,f(root),0,1e-10);
const q=x=>Math.log(x)+2/x;
near("FRQ logarithmic minimum",q(2),1.693,0.0002);
near("FRQ exponential function value",3*1.4**2.5-5,1.957,0.0006);
near("FRQ exponential equation",Math.log(25/3)/Math.log(1.4),6.301,0.0006);
for (const [x,expected] of [[0,2],[1,5],[2,13],[3,35],[4,97],[5,275]]) {
  equal(`FRQ mixed-exponential table x=${x}`,2**x+3**x,expected);
}
near("FRQ quadratic model point 1",-1+6+2,7);
near("FRQ quadratic model point 4",-16+24+2,10);
near("FRQ medication average rate",(160*0.5**(6/4)-160*0.5**(2/4))/4,-14.142,0.001);
const profit=x=>-0.1*(x-20)*(x-80);
near("FRQ profit reference",profit(50),90);
near("FRQ profit average rate",(profit(60)-profit(30))/30,1);
const treeBase=((9.3-6.803)/7.5)**(1/5);
near("FRQ tree base",treeBase,0.803,0.0005);
near("FRQ tree average rate",(6.803-1.8)/5,1.001,0.0005);
near("FRQ logarithmic temperature coefficient",18+(6/Math.log(4))*Math.log(4),24,1e-10);

near("Trig equation solution π/6",Math.cos(Math.PI/3)-Math.sin(Math.PI/6),0,1e-12);
near("Trig equation solution 5π/6",Math.cos(5*Math.PI/3)-Math.sin(5*Math.PI/6),0,1e-12);
near("Trig equation solution 3π/2",Math.cos(3*Math.PI)-Math.sin(3*Math.PI/2),0,1e-12);

if(failures.length){console.error(failures.join("\n"));process.exit(1);}
console.log("PASS: 28 independent numeric/algebraic regression checks.");
