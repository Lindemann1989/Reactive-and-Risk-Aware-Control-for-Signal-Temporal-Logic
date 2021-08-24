classdef SignalTransducer
   properties
       S 
       Lambda 
       Gamma
       Delta
       iota
       lambda_e
       gamma_e
       lambda_s
       gamma_s
       b
       c
       F
   end
   methods
       % Constructor
       function obj = SignalTransducer(S_,Lambda_,Gamma_,Delta_,iota_,c_,F_)
           if nargin > 0
               obj.S = S_;
               obj.Lambda = Lambda_;
               obj.Gamma = Gamma_;
               obj.Delta = Delta_;
               obj.iota = iota_;
               obj.c = c_;
               obj.F = F_;
           end
       end
   end
end