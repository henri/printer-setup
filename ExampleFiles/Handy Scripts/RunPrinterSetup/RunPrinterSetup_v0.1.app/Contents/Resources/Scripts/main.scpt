FasdUAS 1.101.10   ��   ��    k             l     ��  ��      Configuration     � 	 	    C o n f i g u r a t i o n   
  
 l     ����  r         m        �    P r i n t e r S e t u p . s h  o      ���� 40 prtinersetup_script_name prtinerSetup_Script_name��  ��        l    ����  r        m       �   " p r i n t e r _ s e t u p . l o g  o      ���� .0 printersetup_log_name printerSetup_Log_name��  ��        l     ��������  ��  ��        l     ��  ��      Other Varibles     �      O t h e r   V a r i b l e s       l    !���� ! r     " # " m    	 $ $ � % %   # o      ���� *0 printersetup_folder printerSetup_folder��  ��      & ' & l    (���� ( r     ) * ) m     + + � , ,   * o      ���� *0 printersetup_script printerSetup_script��  ��   '  - . - l    /���� / r     0 1 0 m     2 2 � 3 3 " p r i n t e r _ s e t u p . l o g 1 o      ���� $0 printersetup_log printerSetup_Log��  ��   .  4 5 4 l     ��������  ��  ��   5  6 7 6 l     ��������  ��  ��   7  8 9 8 l  Y :���� : T   Y ; ; k   T < <  = > = l   ��������  ��  ��   >  ? @ ? l   ��������  ��  ��   @  A B A l   �� C D��   C Q K Get Printer Setup Path if it has not been set in the configuration section    D � E E �   G e t   P r i n t e r   S e t u p   P a t h   i f   i t   h a s   n o t   b e e n   s e t   i n   t h e   c o n f i g u r a t i o n   s e c t i o n B  F G F Z    � H I���� H =    J K J o    ���� *0 printersetup_folder printerSetup_folder K m     L L � M M   I k    � N N  O P O Q    � Q R S Q k   " w T T  U V U r   " % W X W m   " # Y Y � Z Z V / E x a m p l e F i l e s / H a n d y   S c r i p t s / R u n P r i n t e r S e t u p X o      ���� 0 path_from_root   V  [ \ [ r   & - ] ^ ] l  & + _���� _ I  & +�� `��
�� .earsffdralis        afdr `  f   & '��  ��  ��   ^ o      ���� 0 mypath myPath \  a b a r   . 5 c d c n   . 1 e f e 1   / 1��
�� 
psxp f o   . /���� 0 mypath myPath d o      ���� 0 myposixpath myPosixPath b  g h g r   6 I i j i I  6 E�� k��
�� .sysoexecTEXT���     TEXT k b   6 A l m l b   6 = n o n m   6 9 p p � q q  d i r n a m e   " o o   9 <���� 0 myposixpath myPosixPath m m   = @ r r � s s  "��   j o      ���� 0 parent_folder   h  t u t l  J J�� v w��   v N H if the grep below fails then this droplet is in a non standard location    w � x x �   i f   t h e   g r e p   b e l o w   f a i l s   t h e n   t h i s   d r o p l e t   i s   i n   a   n o n   s t a n d a r d   l o c a t i o n u  y z y I  J _�� {��
�� .sysoexecTEXT���     TEXT { b   J [ | } | b   J W ~  ~ b   J U � � � b   J Q � � � m   J M � � � � �  e c h o   " � o   M P���� 0 parent_folder   � m   Q T � � � � �  "   |   g r e p   "  o   U V���� 0 path_from_root   } m   W Z � � � � �  "��   z  ��� � r   ` w � � � I  ` u�� ���
�� .sysoexecTEXT���     TEXT � b   ` q � � � b   ` m � � � b   ` k � � � b   ` g � � � m   ` c � � � � �  e c h o   " � o   c f���� 0 parent_folder   � m   g j � � � � � . "   |   a w k   ' B E G I N   {   F S   =   " � o   k l���� 0 path_from_root   � m   m p � � � � � & "   }   ;   {   p r i n t   $ 1   } '��   � o      ���� *0 printersetup_folder printerSetup_folder��   R R      ������
�� .ascrerr ****      � ****��  ��   S k    � � �  � � � I    ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���   P  ��� � Z   � � � ����� � =  � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �   � k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���  ��  ��  ��  ��  ��   G  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   �   Set some varibles    � � � � $   S e t   s o m e   v a r i b l e s �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� 40 prtinersetup_script_name prtinerSetup_Script_name � o      ���� *0 printersetup_script printerSetup_script �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� .0 printersetup_log_name printerSetup_Log_name � o      ���� $0 printersetup_log printerSetup_Log �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � / ) Check NVRAM Asset Name has not been set     � � � � R   C h e c k   N V R A M   A s s e t   N a m e   h a s   n o t   b e e n   s e t   �  � � � Q   � � � � � � r   � � � � � I  � ��� ���
�� .sysoexecTEXT���     TEXT � m   � � � � � � � � n v r a m   a s s e t - n a m e   |   c u t   - c   1 2 -   |   a w k   ' B E G I N   {   F S   =   " - "   }   ;   {   p r i n t   $ 1   } '��   � o      ���� 0 room_number   � R      ������
�� .ascrerr ****      � ****��  ��   � r   � � � � � m   � � � � � � �   � o      ���� 0 room_number   �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � $  Stop if there is no NVRAM set    � � � � <   S t o p   i f   t h e r e   i s   n o   N V R A M   s e t �  � � � Z   � � � ����� � =  � � � � � o   � ����� 0 room_number   � m   � � � � � � �   � k   � � � �  � � � I  � ��� � �
�� .sysodlogaskr        TEXT � m   � � � � � � � f E R R O R   :   T h e r e   i s   n o   a s s e t   n a m e   s e t   o n   t h i s   m a c h i n e ! � �� � �
�� 
btns � v   � � � �  ��� � m   � � � � � � � 0 D o   N o t   R u n   P r i n t e r   S e t u p��   � �� � �
�� 
dflt � m   � �����  � �� ���
�� 
disp � m   � ���
�� stic    ��   �  ��   S   � ���  ��  ��   �  l  � ���������  ��  ��    l  � �����~��  �  �~    l  � ��}�}    run printer setup    �		 " r u n   p r i n t e r   s e t u p 

 Q   �P�| k   G  I  �{
�{ .sysoexecTEXT���     TEXT b   	 b    m    �  t o u c h   " o  �z�z $0 printersetup_log printerSetup_Log m   �  " �y
�y 
badm m  �x
�x boovtrue �w�v
�w 
RApw�v    I /�u 
�u .sysoexecTEXT���     TEXT b  !!"! b  #$# m  %% �&&  o p e n   "$ o  �t�t $0 printersetup_log printerSetup_Log" m   '' �((  "  �s)*
�s 
badm) m  ()�r
�r boovtrue* �q)�p
�q 
RApw�p   +,+ l 00�o-.�o  - Z Ttell application "Terminal" to do script "sudo bash \"" & printerSetup_script & "\""   . �// � t e l l   a p p l i c a t i o n   " T e r m i n a l "   t o   d o   s c r i p t   " s u d o   b a s h   \ " "   &   p r i n t e r S e t u p _ s c r i p t   &   " \ " ", 0�n0 I 0G�m12
�m .sysoexecTEXT���     TEXT1 b  09343 b  05565 m  0377 �88  s u d o   b a s h   "6 o  34�l�l *0 printersetup_script printerSetup_script4 m  5899 �::  "2 �k;<
�k 
badm; m  @A�j
�j boovtrue< �i;�h
�i 
RApw�h  �n   R      �g�f�e
�g .ascrerr ****      � ****�f  �e  �|   =>= l QQ�d�c�b�d  �c  �b  > ?@? l QQ�a�`�_�a  �`  �_  @ ABA l QQ�^�]�\�^  �]  �\  B CDC  S  QRD EFE l SS�[�Z�Y�[  �Z  �Y  F G�XG l SS�W�V�U�W  �V  �U  �X  ��  ��   9 HIH l     �T�S�R�T  �S  �R  I JKJ l     �Q�P�O�Q  �P  �O  K LML l     �N�M�L�N  �M  �L  M NON l     �K�J�I�K  �J  �I  O PQP i     RSR I      �H�G�F�H 20 .display_error_determining_printer_setup_folder  �G  �F  S k     TT UVU l     �E�D�C�E  �D  �C  V W�BW I    �AX�@
�A .sysodlogaskr        TEXTX m     YY �ZZD E r r o r   D e t e r m i n i n g   P r i n t e r   S e t u p   F o l d e r .   
 
 Y o u   m a y   n e e d   t o   c o n f i g u r e   t h i s   s c r i p t ,   a s   i t   m a y   h a v e   b e e n   m o v e d   f r o m   i t s   o r i g i n a l   l o c a t i o n   i n   t h e   ' E x a m p l e F i l e s '   f o l d e r�@  �B  Q [�?[ l     �>�=�<�>  �=  �<  �?       �;\]^  _`a Ybcde�:�9�8�7�;  \ �6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�6 20 .display_error_determining_printer_setup_folder  
�5 .aevtoappnull  �   � ****�4 40 prtinersetup_script_name prtinerSetup_Script_name�3 .0 printersetup_log_name printerSetup_Log_name�2 *0 printersetup_folder printerSetup_folder�1 *0 printersetup_script printerSetup_script�0 $0 printersetup_log printerSetup_Log�/ 0 path_from_root  �. 0 mypath myPath�- 0 myposixpath myPosixPath�, 0 parent_folder  �+ 0 room_number  �*  �)  �(  �'  ] �&S�%�$fg�#�& 20 .display_error_determining_printer_setup_folder  �%  �$  f  g Y�"
�" .sysodlogaskr        TEXT�# �j ^ �!h� �ij�
�! .aevtoappnull  �   � ****h k    Ykk  
ll  mm  nn  &oo  -pp  8��  �   �  i  j 6 � � $� +� 2� L Y����� p r�� � � � � � ���� � � � �� � � �� ���
�	�����%'79� 40 prtinersetup_script_name prtinerSetup_Script_name� .0 printersetup_log_name printerSetup_Log_name� *0 printersetup_folder printerSetup_folder� *0 printersetup_script printerSetup_script� $0 printersetup_log printerSetup_Log� 0 path_from_root  
� .earsffdralis        afdr� 0 mypath myPath
� 
psxp� 0 myposixpath myPosixPath
� .sysoexecTEXT���     TEXT� 0 parent_folder  �  �  � 20 .display_error_determining_printer_setup_folder  � 0 room_number  
� 
btns
� 
dflt
�
 
disp
�	 stic    � 
� .sysodlogaskr        TEXT
� 
badm
� 
RApw� �Z�E�O�E�O�E�O�E�O�E�ODhZ��  � Z�E�O)j E�O��,E` Oa _ %a %j E` Oa _ %a %�%a %j Oa _ %a %�%a %j E�W X  *j+ OO�a   *j+ OY hY hO�a %�%E�O�a  %�%E�O a !j E` "W X  a #E` "O_ "a $  "a %a &a 'ka (ka )a *a + ,OY hO La -�%a .%a /ea 0ea 1 Oa 2�%a 3%a /ea 0ea 1 Oa 4�%a 5%a /ea 0ea 1 W X  hOOP[OY��_ �qq J / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 5` �rr j / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 5 / P r i n t e r S e t u p . s ha �ss n / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 5 / p r i n t e r _ s e t u p . l o gb$alis       Local-HD                   ê\�H+   #�ZRunPrinterSetup_v0.1.app                                        #���5��        ����  	                RunPrinterSetup     é��      �5M(     #�Z #'� #&~ #&u 
 W 
 R 
 N  qLocal-HD:Users:smc:Desktop:PrinterSetup_v0025:ExampleFiles:Handy Scripts:RunPrinterSetup:RunPrinterSetup_v0.1.app   2  R u n P r i n t e r S e t u p _ v 0 . 1 . a p p    L o c a l - H D  hUsers/smc/Desktop/PrinterSetup_v0025/ExampleFiles/Handy Scripts/RunPrinterSetup/RunPrinterSetup_v0.1.app  /    
��  c �tt � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 5 / E x a m p l e F i l e s / H a n d y   S c r i p t s / R u n P r i n t e r S e t u p / R u n P r i n t e r S e t u p _ v 0 . 1 . a p p /d �uu � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 5 / E x a m p l e F i l e s / H a n d y   S c r i p t s / R u n P r i n t e r S e t u pe �vv  A R T P R E F A B L I G H T�:  �9  �8  �7   ascr  ��ޭ