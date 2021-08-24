classdef Until
   properties
       ST = SignalTransducer
       p1
       p2
       q
   end
   methods
       % Constructor
       function obj = Until()
           obj.p1 = 'p1';
           obj.p2 = 'p2';
           obj.q = 'q';
           
           obj.ST.S = obj.set_states();
           obj.ST.Lambda = obj.set_Lambda();
           obj.ST.Gamma = obj.set_Gamma();
           obj.ST.Delta = obj.set_Delta();
           obj.ST.iota = obj.set_iota();
           obj.ST.lambda_e = obj.set_lambda_e();
           obj.ST.gamma_e = obj.set_gamma_e();
           obj.ST.lambda_s = obj.set_lambda_s();
           obj.ST.gamma_s = obj.set_gamma_s();
           obj.ST.F{1} = obj.set_F();
           obj.ST.c = {'none'};
           obj.ST.b = {'none'};
           
           
       end
       function r = set_states(obj)
           r = {'s0','s1','s2','s3','s4'};
       end
       function r = set_F(obj)
           r = {'s0','s1','s2','s4'}; % remove s3 here!
       end
       function r = set_Lambda(obj)
           r = {obj.p1,obj.p2};
       end
       function r = set_Gamma(obj)
           r = {obj.q};
       end
       function r = set_Delta(obj)
           % Initial Nodes
           e1 = Edge('s0','s1',{'c0'},{'r0'});
           e2 = Edge('s0','s2',{'c0'},{'r0'});
           e3 = Edge('s0','s3',{'c0'},{'r0'});
           e4 = Edge('s0','s4',{'c0'},{'r0'});
           e5 = Edge('s1','s2',{'c0'},{'r0'});
           e6 = Edge('s2','s1',{'c0'},{'r0'});
           e7 = Edge('s1','s3',{'c0'},{'r0'});
           e8 = Edge('s3','s1',{'c0'},{'r0'});
           e9 = Edge('s1','s4',{'c0'},{'r0'});
           e10 = Edge('s4','s1',{'c0'},{'r0'});
           e11 = Edge('s2','s3',{'c0'},{'r0'});
           e12 = Edge('s3','s2',{'c0'},{'r0'});
           e13 = Edge('s2','s4',{'c0'},{'r0'});
           e14 = Edge('s4','s2',{'c0'},{'r0'});
           e15 = Edge('s3','s4',{'c0'},{'r0'});
           e16 = Edge('s4','s3',{'c0'},{'r0'});
           e17 = Edge('s1','s1',{'c0'},{'r0'});
           e18 = Edge('s2','s2',{'c0'},{'r0'});
           e19 = Edge('s3','s3',{'c0'},{'r0'});
           e20 = Edge('s4','s4',{'c0'},{'r0'});
           r{1} = {e1,e2,e3,e4};
           r{2} = {e5,e7,e9,e17};
           r{3} = {e6,e11,e13,e18};
           r{4} = {e8,e12,e15,e19};
           r{5} = {e10,e14,e16,e20};
       end
       function r = set_iota(obj)
           r = {{'none'},{'c0'},{'c0'},{'c0'},{'c0'}};
       end
       function r = set_lambda_e(obj)
           r{1} = {{'d13'},{'d13'},{'d13'},{'d13'}};
           r{2} = {{'d13'},{'d13'},{'d13'},{'d03'}};
           r{3} = {{'d13'},{'d13'},{'d13'},{'d05'}};
           r{4} = {{'d02'},{'d06'},{'d06'},{'d06'}};
           r{5} = {{'d04'},{'d08'},{'d04'},{'d04'}};
       end
       function r = set_gamma_e(obj)
           r{1} = {{obj.q},{['-' obj.q]},{obj.q},{['-' obj.q]}};
           r{2} = {{['-' obj.q]},{obj.q},{['-' obj.q]},{obj.q}};
           r{3} = {{obj.q},{obj.q},{['-' obj.q]},{['-' obj.q]}};
           r{4} = {{obj.q},{['-' obj.q]},{['-' obj.q]},{obj.q}};
           r{5} = {{obj.q},{['-' obj.q]},{obj.q},{['-' obj.q]}};
       end
       function r = set_lambda_s(obj)
           r = {{'none'},{'d01'},{'d07'},{'d09'},{'d09'}};
       end
       function r = set_gamma_s(obj)
           r = {{'none'},{obj.q},{['-' obj.q]},{obj.q},{['-' obj.q]}};
       end
   end
end