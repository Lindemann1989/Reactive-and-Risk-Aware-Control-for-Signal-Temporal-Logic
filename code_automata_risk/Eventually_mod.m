classdef Eventually_mod
   properties
       ST = SignalTransducer
       clock_nr
       p
       q
   end
   methods
       % Constructor
       function obj = Eventually_mod(val)
           if nargin>0
               obj.clock_nr = val(1);
               obj.ST.b = {num2str(val(2))};
           else
               error('Specify input number, clock number, and b!')
           end
           obj.ST.c = {['c' num2str(obj.clock_nr)]};
           obj.p = 'p';
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
           obj.ST.F{1} = obj.ST.S;
           
           
       end
       function r = set_states(obj)
           r = {'s0','s1','s2','s3'};
       end
       function r = set_Lambda(obj)
           r = {obj.p};
       end
       function r = set_Gamma(obj)
           r = {obj.q};
       end
       function r = set_Delta(obj)
           % Initial Nodes
           e1 = Edge('s0','s1',{'c0'},{'r1'});
           e2 = Edge('s0','s2',{'c0'},{'r1'});
           e3 = Edge('s1','s2',{'c0'},{'r1'});
           e4 = Edge('s2','s1',{'c0'},{'r1'});
           e5 = Edge('s1','s3',{'c0'},{'r1'});
           e6 = Edge('s3','s2',{'c1'},{'r1'});
           r{1} = {e1,e2};
           r{2} = {e3,e5};
           r{3} = {e4};
           r{4} = {e6};
       end
       function r = set_iota(obj)
           r = {{'none'},{'c0'},{'c0'},{'c1'}};
       end
       function r = set_lambda_e(obj)
           r{1} = {{'d13'},{'d13'}};
           r{2} = {{'d13'},{'d13'}};
           r{3} = {{'d13'}};
           r{4} = {{obj.p}};
       end
       function r = set_gamma_e(obj)
           r{1} = {{['-' obj.q]},{obj.q}};
           r{2} = {{obj.q},{obj.q}};
           r{3} = {{['-' obj.q]}};
           r{4} = {{obj.q}};
       end
       function r = set_lambda_s(obj)
           r = {{'none'},{['-' obj.p]},{obj.p},{['-' obj.p]}};
       end
       function r = set_gamma_s(obj)
           r = {{'none'},{['-' obj.q]},{obj.q},{obj.q}};
       end
   end
end

% Resets
% r0: no reset
% r1: reset

% Guards and invariants
% c0: no guard
% c1: c<b
% c2: c=b
% c3: for intersection

%     % Encoding of constraints for two input variables of ST2
%     d01 : p1 a p2
%     d02 : p1 o p2
%     d03 : -(p1 a p2)
%     d04 : -(p1 o p2)
%     d05 : p1
%     d06 : p2
%     d07 : -p1
%     d08 : -p2
%     d09 : p1 a -p2
%     d10: -p1 a p2
%     d11: p1 o -p2
%     d12: -p1 o p2
%     d13: True 