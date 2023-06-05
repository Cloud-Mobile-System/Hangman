var 
  MyForm, MYSecondForm:TCLForm;
  baslaBtn : TclProButton;
  baslikImg,adamImg: TClProImage; 
  secimLbl,cikmayanHarfLbl  : TClProLabel;
  secimCombo : TClComboBox;
  donguCombo ,dongu, source,counter : Integer;
  oyunPanel,harfPanel,cikmayanHarfPanel,ekranPanel,gameContentPnl,imageHintContentPnl,hintContentPnl : TclProPanel;
  strdeger, MyWord, WordMean,karakter:String;
  MyWordMean:TclMemo;
  LblDisplay,ztStartLbl:TclLabel;
  myGameEngine:TclGameEngine;
  MyPanel:TclPanel;
  harfEdit,MyEdit:TclEdit;
  EditFixWidth:Single;
  ztHintBtn,ztStartBtn:TclImage;
  ztLayout,ztHintBtnLayout:TclLayout;
  AnswStr,Kelime:String;
  wrongCount:integer;
  

{ --------------------- Yeni Kelime Alma Prosedürü --------------------- }
  Procedure GetNewWord(wordLength:Integer);
  begin
    myGameEngine:= TclGameEngine.Create;
    MyWord := MyGameEngine.WordService('GETWORD:'+IntToStr(wordLength),'');
    With Clomosy.ClDataSetFromJSON(MyWord) Do 
    Begin
      MyWord := FieldByName('Word').AsString;
      MyWord := AnsiUpperCase(MyWord);
      LblDisplay.Text := MyWord;//UpperCase
      WordMean := FieldByName('MeanText').AsString; //?
      //ShowMessage(MyWord);
    End;
  End;
  
   {--------------- kelime kontrol --------------------}
  Procedure kelimeKontrol;
  var
    j:integer;
  begin
    for j := 1 to StrToInt(secimCombo.ItemIndex)+1 do
    begin
      if harfEdit.Text = '' Then
      begin
        exit;
      end
      else
        kelime := kelime+TClEdit(MYSecondForm.clFindComponent('MyEdit'+IntToStr(j))).Text;
    end;
  
  End;
  
  
  {---------------------kelime bilinip bilinmediğini kontrol------------------------------}
  Procedure CheckGameOnClick;
  begin
    kelime := '';
    kelimeKontrol;
    //AnswStr :=Clomosy.GlobalVariableString;
    AnswStr := kelime;
    AnswStr := AnsiUpperCase(AnswStr);
    If AnswStr=MyWord Then
    begin
      ShowMessage('Tebrikler');
      ztStartBtn.Tag := 0;
      MYSecondForm.setImage(ztStartBtn,'https://clomosy.com/educa/circled-play.png');
      ztStartLbl.Text := 'Start Game';
      cikmayanHarfLbl.Text :='';
      TclProButton(MYSecondForm.clFindComponent('BtnGoBack')).Click;
    end;
    else
    begin
      //
    end;
  end;


  Procedure BtnStartGameClick;
  begin
    case ztStartBtn.Tag of
      0:
      begin
        //MYSecondForm.setImage(ztStartBtn,'https://img.icons8.com/carbon-copy/100/null/checked--v1.png');
        //ztStartLbl.Text := 'Check Word';
        ztStartBtn.Tag := 1; //buton içerisinde veri saklama işlemi yapılabilir. 
        wrongCount := 0;
        GetNewWord(StrToInt(secimCombo.ItemIndex)+1);
        MyWordMean.Text := WordMean;
        harfEdit.Text:='';
        harfEdit.SetFocus;
        LblDisplay.Visible := False;
        ztStartBtn.Visible := False;
        ztStartLbl.Visible := False;
      end;
      1:
      begin
        CheckGameOnClick;
      end;
    end;
  End;
  
  
  Procedure MyEditOnChange;//********************
  var
  harfState:Boolean;
  begin
    harfState:=False;
    source := MyWord;

    for dongu := 1 to secimCombo.ItemIndex+1 do
    begin
      karakter := Copy(source, dongu, 1);
      if harfEdit.Text = karakter then
      begin
        harfState:=True;
        TClEdit(MYSecondForm.clFindComponent('MyEdit'+IntToStr(dongu))).Text := harfEdit.Text;
        CheckGameOnClick;
      end;
    end;
   
    if not harfState then
    begin
      wrongCount := wrongCount +1;
      cikmayanHarfLbl.Text:=cikmayanHarfLbl.Text+ harfEdit.Text + ' , ';
      if wrongCount = 11 then
      begin
        ShowMessage('Kelime: '+'"'+ MyWord+'"' +' Başarısız oldun .');
        MYSecondForm.setImage(ztStartBtn,'https://clomosy.com/educa/checked2.png');
        ztStartLbl.Text := 'Check Word';
        ztStartBtn.Tag := 1;
        wrongCount := 1;
        GetNewWord(StrToInt(secimCombo.ItemIndex));
        MyWordMean.Text := WordMean;
        MyEdit.Text:='';
        
        MyEdit.SetFocus;
        LblDisplay.Visible := False;
        cikmayanHarfLbl.Text:='';
      
        clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,
        "RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,
        "ImgUrl":"https://clomosy.com/educa/hangerTitle2.png", "ImgFit":"yes"}');
        TclProButton(MYSecondForm.clFindComponent('BtnGoBack')).Click;
      end;
      case wrongCount of
      1:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman1.png", "ImgFit":"yes"}');
      2:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman2.png", "ImgFit":"yes"}');
      3:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman3.png", "ImgFit":"yes"}');
      4:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman4.png", "ImgFit":"yes"}');
      5:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman5.png", "ImgFit":"yes"}');
      6:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman6.png", "ImgFit":"yes"}');
      7:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman7.png", "ImgFit":"yes"}');
      8:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman8.png", "ImgFit":"yes"}');
      9:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman9.png", "ImgFit":"yes"}');
      10:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman10.png", "ImgFit":"yes"}');
      11:clComponent.SetupComponent(adamImg,'{"Align" : "Center","MarginLeft":5,"MarginRight":5,"MarginTop":50,"Width" :150, "Height":250,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangman11.png", "ImgFit":"yes"}');
      end;
    end;
 
  end;
  
  {---------------KELİME UZUNLUĞU------------------}
  Procedure SetupLayout;
  begin

    MyPanel:= MYSecondForm.AddNewPanel(gameContentPnl,'MyPanel','');
    MyPanel.Align := alCenter;
    MyPanel.Height := 25;
    MyPanel.Margins.Top:=5;
    MyPanel.Margins.Left:=20;
    MyPanel.Margins.Right:=20;
 
    
    for counter:= 1 to secimCombo.ItemIndex+1 do
    begin
      EditFixWidth := 25;
      MyEdit := MYSecondForm.AddNewEdit(MyPanel,'MyEdit'+IntToStr(counter),'_');
      //MYSecondForm.AddNewEvent(MyEdit,tbeOnChange,'MyEditOnChange');
      MyEdit.Width := EditFixWidth;
      MyEdit.Align := alLeft;
      MyEdit.ReadOnly := True;
   
    end;
    MyPanel.Width := EditFixWidth*(secimCombo.ItemIndex+1);
  end;

//HARFLER
Procedure cikmayanHarf
begin

     cikmayanHarfPanel:=MYSecondForm.AddNewProPanel(gameContentPnl,'cikmayanHarfPanel');
    clComponent.SetupComponent(cikmayanHarfPanel,'{"Align" : "MostTop","Width" :100, "MarginTop":5,
    "Height":50,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":2}');
    
     cikmayanHarfLbl := MYSecondForm.AddNewProLabel(cikmayanHarfPanel,'cikmayanHarfLbl','Harfler : ');
   clComponent.SetupComponent(cikmayanHarfLbl,'{"Align" : "left","MarginBottom":10,"MarginLeft":20,"Width" :250, "Height":30,"TextColor":"#000000","TextSize":12,"TextVerticalAlign":"center",
   "TextHorizontalAlign":"left","TextBold":"yes"}');
   
end;

Procedure harfAl
begin
    harfPanel:=MYSecondForm.AddNewProPanel(gameContentPnl,'harfPanel');
    clComponent.SetupComponent(harfPanel,'{"Align" : "Top","Width" :100, "MarginLeft":140,"MarginRight":140,"MarginTop":10,
    "Height":50,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":2}');
    
    EditFixWidth := 25;
    harfEdit:= MYSecondForm.AddNewEdit(harfPanel,'harfEdit','____');
    MYSecondForm.AddNewEvent(harfEdit,tbeOnChange,'MyEditOnChange');
    harfEdit.Width := EditFixWidth;
    harfEdit.Align := alCenter;
    //MyEdit1.CharCase := 1;//UpperCase;
    harfEdit.MaxLength := 1;

end;

  Procedure SetupStartBtn;
  begin
    ztLayout := MYSecondForm.AddNewLayout(oyunPanel,'ztLayout');
    ztLayout.Align:=alBottom;
    ztLayout.Height := 130;
    ztLayout.Margins.Top := 5;
    
    ztStartBtn:= MYSecondForm.AddNewImage(ztLayout,'ztStartBtn');
    ztStartBtn.Align := alTop;
    ztStartBtn.Height := 100;
    ztStartBtn.Width := 100;
    ztStartBtn.Tag := 0;
    
    MYSecondForm.setImage(ztStartBtn,'https://clomosy.com/educa/circled-play.png');
    MYSecondForm.AddNewEvent(ztStartBtn,tbeOnClick,'BtnStartGameClick');
    
    ztStartLbl:= MYSecondForm.AddNewLabel(ztLayout,'ztStartLbl','Start Game');
    ztStartLbl.StyledSettings := ssFamily;
    ztStartLbl.TextSettings.Font.Size:=20;
    ztStartLbl.Align := alCenter;
    ztStartLbl.Margins.Top := 5;
    ztStartLbl.Margins.Bottom := 5;
    ztStartLbl.Width := 150;
    
  end;
  Procedure ztHintBtnOnClick;
  begin
    LblDisplay.Visible := True;
  end;


{--------------------   HİNT Btn oldugu yer  -------------------------------------------}

  procedure SetupHintBtn;
  begin
    ztHintBtnLayout := MYSecondForm.AddNewLayout(hintContentPnl,'ztHintBtnLayout');
    ztHintBtnLayout.Align:=alClient;
    ztHintBtnLayout.Height := 100;
    ztHintBtnLayout.Width := 130;
    
    ztHintBtn:= MYSecondForm.AddNewImage(ztHintBtnLayout,'ztHintBtn');
    ztHintBtn.Align := alMostTop;
    ztHintBtn.Margins.Left:=30;
    ztHintBtn.Margins.Right:=30;
    ztHintBtn.Height:= 80;
    MYSecondForm.setImage(ztHintBtn,'https://clomosy.com/educa/hint1.png');
    MYSecondForm.AddNewEvent(ztHintBtn,tbeOnClick,'ztHintBtnOnClick');
    
    LblDisplay:= MYSecondForm.AddNewLabel(ztHintBtnLayout,'LblDisplay',' ');
    LblDisplay.Align := alTop;
    LblDisplay.Margins.Left :=5;
    LblDisplay.Margins.Right:= 5;
    LblDisplay.Margins.Top:=5;
    LblDisplay.Height := 30;
    LblDisplay.TextSettings.Font.Size:=3;
    LblDisplay.Visible := True;
    
  end;
  
  
   {----------------------------- Memo ----------------------------------------------}
  Procedure SetupWordMean;
  var
   ztProPanel : TclProPanel;
   begin
    ztProPanel:=MYSecondForm.AddNewProPanel(oyunPanel,'ztProPanel');
    clComponent.SetupComponent(ztProPanel,'{"Align" : "MostTop","Width" :80, "MarginTop":10,"MarginRight":10,"MarginLeft":10, 
    "Height":100,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":2}');
    
    MyWordMean:= MYSecondForm.AddNewMemo(ztProPanel,'MyWordMean','');
    MyWordMean.Align := alClient;
    MyWordMean.ReadOnly := True;
    MyWordMean.TextSettings.WordWrap := True;
    MyWordMean.Height := MyWordMean.Height * 2;
   end;
  
  Procedure gameContent;
  begin
  
  gameContentPnl:=MyForm.AddNewProPanel(oyunPanel,'gameContentPnl');
  clComponent.SetupComponent(gameContentPnl,'{"Align" : "Top","MarginTop":10, "MarginLeft":5,"MarginRight":5,
  "Height":400}');
  
  //ALT KISMINA RESİM VE İPUCU BİLGİLERİ
  imageHintContentPnl:=MyForm.AddNewProPanel(gameContentPnl,'imageHintContentPnl');
  clComponent.SetupComponent(imageHintContentPnl,'{"Align" : "Bottom","MarginTop":10,"MarginLeft":5,"MarginRight":5,
  "Height":250}');

    adamImg := MYSecondForm.AddNewProImage(imageHintContentPnl,'adamImg');
    clComponent.SetupComponent(adamImg,'{"Align" : "Right","RoundHeight":10,"RoundWidth":10,"MarginTop":5,"MarginBottom":5,
    "BorderColor":"#000000","BorderWidth":0,"ImgUrl":"https://clomosy.com/educa/hangerTitle2.png","ImgFit":"yes"}');
    
    //HİNT VE HİNT BUTON ALANI
    hintContentPnl:=MyForm.AddNewProPanel(imageHintContentPnl,'hintContentPnl');
    clComponent.SetupComponent(hintContentPnl,'{"Align" : "Left","MarginTop":10,"MarginLeft":5,"Width":130}');
    
    SetupHintBtn;
  
  end;
  
  Procedure ekraniki;
  begin
    MYSecondForm := TCLForm.Create(Self);
    MYSecondForm.SetFormColor('#6af2e4','#CBEDD5',clGVertical);
    
    
    strdeger:=5;
    oyunPanel:=MYSecondForm.AddNewProPanel(MYSecondForm,'oyunPanel');
    clComponent.SetupComponent(oyunPanel,'{"Align" : "Client","MarginRight":10,"MarginLeft":10,
    "MarginBottom":10,"MarginTop":10,"RoundHeight":10,"RoundWidth":10,
    "BorderColor":"#000000","BorderWidth":2}');
    
    SetupWordMean;  //MEMO
    
    gameContent;
    
    SetupLayout;
    SetupStartBtn;
    harfAl;
    cikmayanHarf;
    
    MYSecondForm.Run;
  End;



procedure BtnOnClick;
var
  valueStr : String;
begin
  if secimCombo.ItemIndex <> 0 then 
    ekraniki;
  else
    ShowMessage('Seçim Yapınız');
    
end;



begin

  MyForm := TCLForm.Create(Self);
  MyForm.SetFormColor('#6af2e4','#CBEDD5',clGVertical);

 ekranPanel:=MyForm.AddNewProPanel(MyForm,'ekranPanel');
 clComponent.SetupComponent(ekranPanel,'{"Align" : "Client","Width" :300, "MarginTop":15,"MarginRight":15,"MarginLeft":15,"MarginBottom":15,
 "Height":600,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#000000","BorderWidth":2}');


 baslikImg := MyForm.AddNewProImage(ekranPanel,'baslikImg');
 clComponent.SetupComponent(baslikImg,'{"Align" : "Top","MarginTop":45,"MarginRight":15,"MarginLeft":15,"Width" :150, "Height":150,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#fabd2","BorderWidth":0,
 "ImgUrl":"https://clomosy.com/educa/hangerTitle.png", "ImgFit":"yes"}');



 secimLbl := MyForm.AddNewProLabel(ekranPanel,'secimLbl','Kelime Uzunlugu Seçin ');
 clComponent.SetupComponent(secimLbl,'{"Align" : "Center",
 "MarginBottom":100,
 "Width" :150,
 "Height":30,
 "TextColor":"#000000",
 "TextSize":14,
 "TextVerticalAlign":"center",
 "TextHorizontalAlign":"left",
 "TextBold":"yes"}');


  secimCombo := MyForm.AddNewComboBox(ekranPanel,'secimCombo');
  secimCombo.Align := alCenter;
  secimCombo.Width := 150;
  secimCombo.Margins.Bottom:=20;
  
  secimCombo.AddItem('Seçiminizi Yapın','0')
  
  for donguCombo := 2 to 10 do 
  begin
   secimCombo.AddItem(IntToStr(donguCombo),IntToStr(donguCombo));
  end;

   baslaBtn := MyForm.AddNewProButton(ekranPanel,'baslaBtn','');
   clComponent.SetupComponent(baslaBtn,'{"caption":"","Align" : "Bottom","MarginBottom":40,"Width" :100, 
   "Height":70,"RoundHeight":2,
   "RoundWidth":2,"BorderColor":"#000000","BorderWidth":2}');
   MyForm.SetImage(baslaBtn,'https://clomosy.com/educa/hanger.png'); 
   MyForm.AddNewEvent(baslaBtn,tbeOnClick,'BtnOnClick');

MyForm.Run;
end;
