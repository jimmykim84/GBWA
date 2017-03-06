function p=COR(X,Y)

  Xzm= X-mean(mean(X));
  Yzm= Y-mean(mean(Y));
  p=sum(dot(Xzm,Yzm))/((sum(dot(Xzm,Xzm))^0.5)*(sum(dot(Yzm,Yzm))^0.5));        
