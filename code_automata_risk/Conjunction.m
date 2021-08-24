classdef Conjunction
   properties
       ST = SignalTransducer
       p1
       p2
       q
   end
   methods
       % Constructor
       function obj = Conjunction()
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
           obj.ST.b = {'none'};
           obj.ST.c = {'none'};
           obj.ST.F{1} = obj.ST.S;
       end
       function r = set_states(obj)
           r = {'s0','s1','s2'};
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
           e2 = Edge('s0','s1',{'c0'},{'r0'});
           e3 = Edge('s0','s2',{'c0'},{'r0'});
           e4 = Edge('s0','s2',{'c0'},{'r0'});
           e5 = Edge('s1','s2',{'c0'},{'r0'});
           e6 = Edge('s1','s2',{'c0'},{'r0'});
           e7 = Edge('s2','s1',{'c0'},{'r0'});
           e8 = Edge('s2','s1',{'c0'},{'r0'});
           e9 = Edge('s1','s1',{'c0'},{'r0'});
           e10 = Edge('s2','s2',{'c0'},{'r0'});
           r{1} = {e1,e2,e3,e4};
           r{2} = {e5,e6,e9};
           r{3} = {e7,e8,e10};
       end
       function r = set_iota(obj)
           r = {{'none'},{'c0'},{'c0'}};
       end
       function r = set_lambda_e(obj)
           i1 = 'd03';
           i2 = 'd01';
           r{1} = {{i1},{i2},{i1},{i2}};
           r{2} = {{i1},{i2},{i2}};
           r{3} = {{i1},{i2},{i1}};
       end
       function r = set_gamma_e(obj)
           r{1} = {{['-' obj.q]},{obj.q},{['-' obj.q]},{obj.q}};
           r{2} = {{['-' obj.q]},{obj.q},{obj.q}};
           r{3} = {{['-' obj.q]},{obj.q},{['-' obj.q]}};
       end
       function r = set_lambda_s(obj)
           i1 = 'd03';
           i2 = 'd01';
           r = {{'none'},{i1},{i2}};
       end
       function r = set_gamma_s(obj)
           r = {{'none'},{['-' obj.q]},{obj.q}};
       end
   end
end