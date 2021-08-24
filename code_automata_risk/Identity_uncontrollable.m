classdef Identity_uncontrollable
   properties
       ST = SignalTransducer
       p
       q
       clock_nr
   end
   methods
       % Constructor
       function obj = Identity_uncontrollable(p,val)
           if nargin>0
               obj.clock_nr = val(1);
               obj.ST.b = {num2str(val(2))};
           else
               error('Specify input number, clock number, and b!')
           end
           obj.p = p;
           obj.q = 'q';
           obj.ST.c = {['c' num2str(obj.clock_nr)]};
           
           obj.ST.S = obj.set_states();
           obj.ST.Lambda = obj.set_Lambda();
           obj.ST.Gamma = obj.set_Gamma();
           obj.ST.Delta = obj.set_Delta();
           obj.ST.iota = obj.set_iota();
           obj.ST.lambda_e = obj.set_lambda_e();
           obj.ST.gamma_e = obj.set_gamma_e();
           obj.ST.lambda_s = obj.set_lambda_s();
           obj.ST.gamma_s = obj.set_gamma_s();
           obj.ST.F{1} = obj.ST.S;
       end
       function r = set_states(obj)
           r = {'s0','s1'};
       end
       function r = set_Lambda(obj)
           r = {obj.p};
       end
       function r = set_Gamma(obj)
           r = {obj.q};
       end
       function r = set_Delta(obj)
           % Initial Nodes
           % We here do not consider the uncontrollable proposition to be
           % true initially
           e1 = Edge('s0','s1',{'c0'},{'r0'});
           %e2 = Edge('s0','s1',{'c0'},{'r1'});
%            e3 = Edge('s0','s2',{'c0'},{'r0'});
%            e4 = Edge('s0','s2',{'c0'},{'r0'});
%            e5 = Edge('s1','s2',{'c0'},{'r0'});
%            e6 = Edge('s1','s2',{'c0'},{'r0'});
%            e7 = Edge('s2','s1',{'c0'},{'r0'});
%            e8 = Edge('s2','s1',{'c0'},{'r0'});
           e9 = Edge('s1','s1',{'c4'},{'r1'});
%           e10 = Edge('s2','s2',{'c0'},{'r0'});
           r{1} = {e1};
           r{2} = {e9};
       end
       function r = set_iota(obj)
           r = {{'none'},{'c0'}};
       end
       function r = set_lambda_e(obj)
           r{1} = {{['-' obj.p]}};
           r{2} = {{obj.p}};
       end
       function r = set_gamma_e(obj)
           r{1} = {{['-' obj.q]}};
           r{2} = {{obj.q}};
       end
       function r = set_lambda_s(obj)
           r = {{'none'},{['-' obj.p]}};
       end
       function r = set_gamma_s(obj)
           r = {{'none'},{['-' obj.q]}};
       end
   end
end