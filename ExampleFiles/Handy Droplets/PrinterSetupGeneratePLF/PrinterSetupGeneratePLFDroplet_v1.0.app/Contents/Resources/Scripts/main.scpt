FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        i      	 
 	 I     �� ��
�� .aevtodocnull  �    alis  o      ���� 0 itemlist itemList��   
 k    �       l     ��������  ��  ��        l     ��  ��    � |----------------------------------------------------------------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��    � �                                                             Configuration                                                                       --     �  &                                                                                                                           C o n f i g u r a t i o n                                                                                                                                               - -      l     ��  ��    � |----------------------------------------------------------------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��������  ��  ��       !   l     ��������  ��  ��   !  " # " l     �� $ %��   $   Configuration    % � & &    C o n f i g u r a t i o n #  ' ( ' r      ) * ) m      + + � , , � E x a m p l e F i l e s / H a n d y   D r o p l e t s / P r i n t e r S e t u p G e n e r a t e P L F / s h - a d d - p s f - t o - l i s t . b a s h * o      ���� h0 2prtinersetup_add_psf_to_list_script_path_from_root 2prtinerSetup_add_psf_to_list_script_path_from_root (  - . - r     / 0 / m     1 1 � 2 2 " p r i n t e r _ s e t u p . l o g 0 o      ���� .0 printersetup_log_name printerSetup_Log_name .  3 4 3 r     5 6 5 m    	 7 7 � 8 8  P r i n t e r L i s t s 6 o      ���� &0 printerlists_name printerLists_name 4  9 : 9 l   ��������  ��  ��   :  ; < ; l   �� = >��   =   Other Varibles    > � ? ?    O t h e r   V a r i b l e s <  @ A @ r     B C B m     D D � E E   C o      ���� 0 add_psf_to_list_script   A  F G F r     H I H m     J J � K K   I o      ���� *0 printersetup_folder printerSetup_folder G  L M L r     N O N m     P P � Q Q   O o      ���� 0 printerlists printerLists M  R S R r     T U T m     V V � W W " p r i n t e r _ s e t u p . l o g U o      ���� $0 printersetup_log printerSetup_Log S  X Y X l   ��������  ��  ��   Y  Z [ Z l   ��������  ��  ��   [  \ ] \ l   �� ^ _��   ^ � }----------------------------------------------------------------------------------------------------------------------------	    _ � ` ` � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 	 ]  a b a l   ��������  ��  ��   b  c d c l   ��������  ��  ��   d  e f e T   � g g k   !� h h  i j i l  ! !��������  ��  ��   j  k l k l  ! !��������  ��  ��   l  m n m l  ! !�� o p��   o Q K Get Printer Setup Path if it has not been set in the configuration section    p � q q �   G e t   P r i n t e r   S e t u p   P a t h   i f   i t   h a s   n o t   b e e n   s e t   i n   t h e   c o n f i g u r a t i o n   s e c t i o n n  r s r Z   ! � t u���� t =  ! $ v w v o   ! "���� *0 printersetup_folder printerSetup_folder w m   " # x x � y y   u k   ' � z z  { | { Q   ' | } ~  } k   * m � �  � � � r   * - � � � m   * + � � � � � h / E x a m p l e F i l e s / H a n d y   D r o p l e t s / P r i n t e r S e t u p G e n e r a t e P L F � o      ���� 0 path_from_root   �  � � � r   . 5 � � � l  . 3 ����� � I  . 3�� ���
�� .earsffdralis        afdr �  f   . /��  ��  ��   � o      ���� 0 mypath myPath �  � � � r   6 ; � � � n   6 9 � � � 1   7 9��
�� 
psxp � o   6 7���� 0 mypath myPath � o      ���� 0 myposixpath myPosixPath �  � � � r   < G � � � I  < E�� ���
�� .sysoexecTEXT���     TEXT � b   < A � � � b   < ? � � � m   < = � � � � �  d i r n a m e   " � o   = >���� 0 myposixpath myPosixPath � m   ? @ � � � � �  "��   � o      ���� 0 parent_folder   �  � � � l  H H�� � ���   � N H if the grep below fails then this droplet is in a non standard location    � � � � �   i f   t h e   g r e p   b e l o w   f a i l s   t h e n   t h i s   d r o p l e t   i s   i n   a   n o n   s t a n d a r d   l o c a t i o n �  � � � I  H W�� ���
�� .sysoexecTEXT���     TEXT � b   H S � � � b   H O � � � b   H M � � � b   H K � � � m   H I � � � � �  e c h o   " � o   I J���� 0 parent_folder   � m   K L � � � � �  "   |   g r e p   " � o   M N���� 0 path_from_root   � m   O R � � � � �  "��   �  ��� � r   X m � � � I  X k�� ���
�� .sysoexecTEXT���     TEXT � b   X g � � � b   X c � � � b   X a � � � b   X ] � � � m   X [ � � � � �  e c h o   " � o   [ \���� 0 parent_folder   � m   ] ` � � � � � . "   |   a w k   ' B E G I N   {   F S   =   " � o   a b���� 0 path_from_root   � m   c f � � � � � & "   }   ;   {   p r i n t   $ 1   } '��   � o      ���� *0 printersetup_folder printerSetup_folder��   ~ R      ������
�� .ascrerr ****      � ****��  ��    k   u | � �  � � � I   u z�������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   { |��   |  ��� � Z   } � � ����� � =  } � � � � o   } ~���� *0 printersetup_folder printerSetup_folder � m   ~ � � � � � �   � k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���  ��  ��  ��  ��  ��   s  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   �   Set some varibles    � � � � $   S e t   s o m e   v a r i b l e s �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� h0 2prtinersetup_add_psf_to_list_script_path_from_root 2prtinerSetup_add_psf_to_list_script_path_from_root � o      ���� 0 add_psf_to_list_script   �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� &0 printerlists_name printerLists_name � o      ���� 0 printerlists printerLists �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� .0 printersetup_log_name printerSetup_Log_name � o      ���� $0 printersetup_log printerSetup_Log �  � � � l  � ���������  ��  ��   �    l  � ���������  ��  ��    r   � � m   � � � N S p e c i f y   t h e   n a m e   o f   t h e   o u t p u t   P L F   f i l e o      ���� 0 request_text   	 l  � ���������  ��  ��  	 

 r   � � m   � ���
�� boovfals o      ���� 0 usercanceled userCanceled  l  � ���������  ��  ��    l  � �����   ' ! grab the name of the output file    � B   g r a b   t h e   n a m e   o f   t h e   o u t p u t   f i l e  r   � � I  � ���
�� .sysodlogaskr        TEXT o   � ����� 0 request_text   ��
�� 
dtxt m   � � � $ P S F - A u t o - G e n e r a t e d � 
� 
btns J   � �!! "#" m   � �$$ �%%  C a n c e l# &�~& m   � �'' �((  G e n e r a t e   P S F�~    �})*
�} 
dflt) m   � �++ �,,  G e n e r a t e   P S F* �|-.
�| 
cbtn- m   � �// �00  C a n c e l. �{12
�{ 
appr1 m   � �33 �44 j P r o v i d e   a   N a m e   F o r   T h e   O u t p u t   P L F   ( P r i n t e r   L i s t   F i l e )2 �z56
�z 
givu5 m   � ��y�y  6 �x7�w
�x 
disp7 m   � ��v
�v stic   �w   o      �u�u 0 dialogresult dialogResult 898 l  � ��t�s�r�t  �s  �r  9 :;: Z   �<=>�q< =  � �?@? n   � �ABA 1   � ��p
�p 
bhitB o   � ��o�o 0 dialogresult dialogResult@ m   � �CC �DD  C a n c e l=  S   > EFE = GHG n  	IJI 1  	�n
�n 
bhitJ o  �m�m 0 dialogresult dialogResultH m  	KK �LL  G e n e r a t e   P S FF M�lM r  NON n  PQP 1  �k
�k 
ttxtQ o  �j�j 0 dialogresult dialogResultO o      �i�i "0 output_psf_name output_PSF_name�l  �q  ; RSR l �h�g�f�h  �g  �f  S TUT l �eVW�e  V #  If you got no name then exit   W �XX :   I f   y o u   g o t   n o   n a m e   t h e n   e x i tU YZY Z )[\�d�c[ = !]^] o  �b�b "0 output_psf_name output_PSF_name^ m   __ �``  \  S  $%�d  �c  Z aba l **�a�`�_�a  �`  �_  b cdc l **�^ef�^  e 	 try   f �gg  t r yd hih X  *�j�]kj k  >ll mnm l >>�\�[�Z�\  �[  �Z  n opo l >>�Yqr�Y  q P Jconverts the apple path to posix, so the path is usable within the shell.    r �ss � c o n v e r t s   t h e   a p p l e   p a t h   t o   p o s i x ,   s o   t h e   p a t h   i s   u s a b l e   w i t h i n   t h e   s h e l l .  p tut r  >Gvwv n  >Cxyx 1  AC�X
�X 
psxpy o  >A�W�W 0 nextitem nextItemw o      �V�V 0 itempath itemPathu z{z l HH�U�T�S�U  �T  �S  { |}| r  H[~~ I HW�R��Q
�R .sysoexecTEXT���     TEXT� b  HS��� b  HO��� m  HK�� ���  b a s e n a m e   "� o  KN�P�P 0 itempath itemPath� m  OR�� ���  "�Q   o      �O�O 0 	item_name  } ��� l \\�N�M�L�N  �M  �L  � ��� l \\�K���K  � $ display dialog output_PSF_name   � ��� < d i s p l a y   d i a l o g   o u t p u t _ P S F _ n a m e� ��� I \}�J��I
�J .sysoexecTEXT���     TEXT� b  \y��� b  \u��� b  \s��� b  \o��� b  \m��� b  \i��� b  \e��� b  \a��� m  \_�� ���  "� o  _`�H�H 0 add_psf_to_list_script  � m  ad�� ���  "   "� o  eh�G�G 0 	item_name  � m  il�� ���  "   "� o  mn�F�F 0 printerlists printerLists� m  or�� ���  /� o  st�E�E "0 output_psf_name output_PSF_name� m  ux�� ���  "�I  � ��� l ~~�D�C�B�D  �C  �B  � ��A� l ~~�@�?�>�@  �?  �>  �A  �] 0 nextitem nextItemk o  -.�=�= 0 itemlist itemListi ��� l ���<�;�:�<  �;  �:  � ��9�  S  ���9   f ��� l ���8�7�6�8  �7  �6  � ��� l ���5�4�3�5  �4  �3  � ��� l ���2���2  �   open the output file   � ��� *   o p e n   t h e   o u t p u t   f i l e� ��� I ���1��0
�1 .sysoexecTEXT���     TEXT� b  ����� b  ����� b  ����� b  ����� m  ���� ���  o p e n   "� o  ���/�/ 0 printerlists printerLists� m  ���� ���  /� o  ���.�. "0 output_psf_name output_PSF_name� m  ���� ���  "�0  � ��-� l ���,�+�*�,  �+  �*  �-    ��� l     �)�(�'�)  �(  �'  � ��� i    ��� I     �&�%�$
�& .aevtoappnull  �   � ****�%  �$  � O     ��� k    �� ��� I   	�#�"�!
�# .miscactvnull��� ��� null�"  �!  � �� � I  
 ���
� .sysodlogaskr        TEXT� m   
 �� ��� � P l e a s e   D r a g   P S F   F i l e s   o n t o   t h e   m e   i n   o r d e r   t o   c r e a t e   a   P L F   f i l e .�  �   � m     ���                                                                                  MACS   alis    t  SwiftMacDrive              �lBH+   
��
Finder.app                                                      
�s�1J�        ����  	                CoreServices    �k�R      �0�     
�� 
�3 
�1  4SwiftMacDrive:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p    S w i f t M a c D r i v e  &System/Library/CoreServices/Finder.app  / ��  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i    ��� I      ���� 20 .display_error_determining_printer_setup_folder  �  �  � k     �� ��� l     ����  �  �  � ��� I    ���
� .sysodlogaskr        TEXT� m     �� ���D E r r o r   D e t e r m i n i n g   P r i n t e r   S e t u p   F o l d e r .   
 
 Y o u   m a y   n e e d   t o   c o n f i g u r e   t h i s   s c r i p t ,   a s   i t   m a y   h a v e   b e e n   m o v e d   f r o m   i t s   o r i g i n a l   l o c a t i o n   i n   t h e   ' E x a m p l e F i l e s '   f o l d e r�  �  �       �
�����
  � �	��
�	 .aevtodocnull  �    alis
� .aevtoappnull  �   � ****� 20 .display_error_determining_printer_setup_folder  � � 
�����
� .aevtodocnull  �    alis� 0 itemlist itemList�  � ��� ��������������������������������� 0 itemlist itemList� h0 2prtinersetup_add_psf_to_list_script_path_from_root 2prtinerSetup_add_psf_to_list_script_path_from_root�  .0 printersetup_log_name printerSetup_Log_name�� &0 printerlists_name printerLists_name�� 0 add_psf_to_list_script  �� *0 printersetup_folder printerSetup_folder�� 0 printerlists printerLists�� $0 printersetup_log printerSetup_Log�� 0 path_from_root  �� 0 mypath myPath�� 0 myposixpath myPosixPath�� 0 parent_folder  �� 0 request_text  �� 0 usercanceled userCanceled�� 0 dialogresult dialogResult�� "0 output_psf_name output_PSF_name�� 0 nextitem nextItem�� 0 itempath itemPath�� 0 	item_name  � > + 1 7 D J P V x ����� � ��� � � � � � ������� � � � �����$'��+��/��3������������CK��_����������������
�� .earsffdralis        afdr
�� 
psxp
�� .sysoexecTEXT���     TEXT��  ��  �� 20 .display_error_determining_printer_setup_folder  
�� 
dtxt
�� 
btns
�� 
dflt
�� 
cbtn
�� 
appr
�� 
givu
�� 
disp
�� stic   �� 
�� .sysodlogaskr        TEXT
�� 
bhit
�� 
ttxt
�� 
kocl
�� 
cobj
�� .corecnte****       ****���E�O�E�O�E�O�E�O�E�O�E�O�E�OnhZ��  n H�E�O)j 	E�O��,E�O�%�%j E�O�%�%�%a %j Oa �%a %�%a %j E�W X  *j+ OO�a   *j+ OY hY hO�a %�%E�O�a %�%E�O�a %�%E�Oa E�OfE�O�a a a a a  lva !a "a #a $a %a &a 'ja (a )a * +E�O�a ,,a -  Y �a ,,a .  �a /,E�Y hO�a 0  Y hO Y�[a 1a 2l 3kh ] �,E^ Oa 4] %a 5%j E^ Oa 6�%a 7%] %a 8%�%a 9%�%a :%j OP[OY��O[OY��Oa ;�%a <%�%a =%j OP� �����������
�� .aevtoappnull  �   � ****��  ��  �  � ������
�� .miscactvnull��� ��� null
�� .sysodlogaskr        TEXT�� � *j O�j U� ������������� 20 .display_error_determining_printer_setup_folder  ��  ��  �  � ���
�� .sysodlogaskr        TEXT�� �j  ascr  ��ޭ