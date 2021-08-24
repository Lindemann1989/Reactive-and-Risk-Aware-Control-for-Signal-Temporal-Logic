classdef True
   properties
       ST = SignalTransducer
       p
       q
   end
   methods
       % Constructor
       function obj = True
           obj.p = 'true';
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
           obj.ST.c = {'none'};
           obj.ST.b = {'none'};
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
           e1 = Edge('s0','s1',{'c0'},{'r0'});
           r{1} = {e1};
           r{2} = {};
       end
       function r = set_iota(obj)
           r = {{'none'},{'c0'}};
       end
       function r = set_lambda_e(obj)
           r{1} = {{obj.p}};
       end
       function r = set_gamma_e(obj)
           r{1} = {{obj.q}};
       end
       function r = set_lambda_s(obj)
           r = {{'none'},{obj.p}};
       end
       function r = set_gamma_s(obj)
           r = {{'none'},{obj.q}};
       end
   end
end