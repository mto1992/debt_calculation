require 'sinatra'
require 'sinatra/reloader'
require 'cgi'



get '/' do

    erb :index

end

get '/test.html' do
  "Hello World"
end

get '/contact_new'do
  erb:contact_form
end

post '/contacts' do
  p params
   redirect '/' #この記述でトップページにリダイレクトできる
end

post '/calculation_result' do
p params

 ganpon = params[:ganpon] #支払の基準となるため変動してはいけない
 payment_obligations = ganpon.to_i #ganponをコピーした値、ここから支払ごとに減算していく
 bunkatu = params[:bunkatu] #一月に一回支払を想定
 siharaiganpon = ganpon.to_i / bunkatu.to_i #【端数発生に要注意！最終支払には端数を合算してください！】変動しないganponと変動する要素のないbunkatuで計算するため一定値
 nenri = params[:nenri]
 geturi = nenri.to_i/12.to_f
 roundgeturi =geturi.round(2)

sumrisoku = 0
sum_pay =0
pay_count = 0

  params[:in_payment] =[]
  if payment_obligations >= 1
        while payment_obligations >=1
        monthly_interest =((payment_obligations *roundgeturi)/100).ceil
        
        if payment_obligations >= siharaiganpon*2
      
         pay_each_time= "元本は#{payment_obligations}円、通常の支払いです、支払利息は#{monthly_interest}円のため#{siharaiganpon + monthly_interest}円を支払います、元本は#{payment_obligations - siharaiganpon}円です"
          payment_obligations -= siharaiganpon
          sumrisoku += monthly_interest
          sum_pay +=siharaiganpon + monthly_interest
          pay_count += 1
        params[:in_payment].push(pay_each_time)
      
         else
             last_payment = "元本は#{payment_obligations}円、端数を含めた全額を支払います、支払利息は#{monthly_interest}円のため#{siharaiganpon + monthly_interest}円を全て返済して完済です！"
             payment_obligations -= payment_obligations
             sumrisoku += monthly_interest
             sum_pay +=siharaiganpon + monthly_interest
             pay_count += 1
            params[:last_payment] = last_payment
        end
       end
       
          params[:full_payment]= "これまでの支払回数は#{pay_count}回、利息の合計額は#{sumrisoku}円、返済総額は#{sum_pay}円です"
  else
     params[:error] = "計算不可能です、再度入力お願いします！"
  end


#ここから試験用
y = 0
params[:y_arrays] = []
  while y <=10
  pay_each_time= "yの現在の値は#{y}です" 
 y += 1
    params[:y_arrays].push(pay_each_time)
end
params[:y_arrays].each {|xxx| puts xxx }
#ここまで試験用

  erb:calculation_result
end

post '/contact' do
  "Hello World"
end

get '/revolving_credit' do
  erb:revolving_credit
  
end

post '/revolving_result' do
  p params
  
ganpon = params[:ganpon] #支払の基準となるため変動してはいけない
payment_obligations = ganpon.to_i #ganponをコピーした値、ここから支払ごとに減算していく
nenri = params[:nenri]
geturi = nenri.to_i/12.to_f
roundgeturi =geturi.round(2)
# x = (nenri/12.to_f).round(2)  を打つことにより年利→月利変換と小数点2桁までに約す事ができるが、3桁以降も含めた計算と比べると金利計算に差異が出てしまうため
params_revolving =params[:revolving] #リボ払いにおける毎月支払い額、この値から金利を支払った後に残額を元本と相殺する。
revolving = params_revolving.to_i

 sumrisoku = 0
 pay_count = 0
 sum_pay = 0
 params[:in_revolving] = []
 
 
  if revolving >= ((payment_obligations *roundgeturi)/100).ceil
     while payment_obligations>=1
     if payment_obligations >= revolving
       monthly_interest =((payment_obligations *roundgeturi)/100).ceil
        revolving_each_time = "元本は#{payment_obligations}円のため#{revolving}円をそのまま支払います、支払利息は#{monthly_interest}円、元本返済分は#{revolving-monthly_interest}円、元本は#{payment_obligations - (revolving-monthly_interest)}円です"
        
        payment_obligations -= (revolving-monthly_interest)
        sumrisoku += monthly_interest
        pay_count += 1
        sum_pay +=revolving
       params[:in_revolving].push(revolving_each_time)
     else
        
        monthly_interest =((payment_obligations *roundgeturi)/100).ceil
        params[:last_revolving] = "元本は#{payment_obligations}円であり#{revolving}円も支払う必要はなく、支払利息の#{monthly_interest}円と元本返済分の合計#{payment_obligations+monthly_interest}円を全て返済して完済です！"
        sum_pay +=payment_obligations+monthly_interest
        sumrisoku +=monthly_interest
        payment_obligations -= payment_obligations
        pay_count += 1
    
     end
     end
     params[:full_revolving] = "これまでの支払回数は#{pay_count}回、利息の合計額は#{sumrisoku}円、返済総額は#{sum_pay}円です"
      
  else
      params[:error] = "毎月の支払額が金利を下回っているため永遠に返済不可能です、再度入力お願いします！"
    end
      
      erb:revolving_result
    end