FasdUAS 1.101.10   ��   ��    k             l     ��  ��      Configuration     � 	 	    C o n f i g u r a t i o n   
  
 l     ����  r         m        �   � E x a m p l e F i l e s / I m p o r t E x p o r t / C U P S / s h - g e n e r a t e - p s f - f i l e s - f r o m - c u p s . b a s h  o      ���� ^0 -prtinersetup_import_cups_script_name_and_path -prtinerSetup_import_cups_script_name_and_path��  ��        l    ����  r        m       �   " p r i n t e r _ s e t u p . l o g  o      ���� .0 printersetup_log_name printerSetup_Log_name��  ��        l    ����  r        m    	   �   " P r i n t e r S e t u p F i l e s  o      ���� 00 printersetupfiles_name printerSetupFiles_name��  ��         l     ��������  ��  ��      ! " ! l     �� # $��   #   Other Varibles    $ � % %    O t h e r   V a r i b l e s "  & ' & l    (���� ( r     ) * ) m     + + � , ,   * o      ���� *0 printersetup_folder printerSetup_folder��  ��   '  - . - l    /���� / r     0 1 0 m     2 2 � 3 3   1 o      ���� *0 printersetup_script printerSetup_script��  ��   .  4 5 4 l    6���� 6 r     7 8 7 m     9 9 � : : " p r i n t e r _ s e t u p . l o g 8 o      ���� $0 printersetup_log printerSetup_Log��  ��   5  ; < ; l    =���� = r     > ? > m     @ @ � A A  / t m p ? o      ���� .0 printersetupfiles_dir PrinterSetupFiles_dir��  ��   <  B C B l     ��������  ��  ��   C  D E D l     ��������  ��  ��   E  F G F l     ��������  ��  ��   G  H I H l  b J���� J T   b K K k   !] L L  M N M l  ! !��������  ��  ��   N  O P O l  ! !��������  ��  ��   P  Q R Q l  ! !�� S T��   S Q K Get Printer Setup Path if it has not been set in the configuration section    T � U U �   G e t   P r i n t e r   S e t u p   P a t h   i f   i t   h a s   n o t   b e e n   s e t   i n   t h e   c o n f i g u r a t i o n   s e c t i o n R  V W V Z   ! � X Y���� X =  ! $ Z [ Z o   ! "���� *0 printersetup_folder printerSetup_folder [ m   " # \ \ � ] ]   Y k   ' � ^ ^  _ ` _ Q   ' � a b c a k   * � d d  e f e r   * / g h g m   * + i i � j j T / E x a m p l e F i l e s / H a n d y   S c r i p t s / I m p o r t F r o m C U P S h o      ���� 0 path_from_root   f  k l k r   0 9 m n m l  0 5 o���� o I  0 5�� p��
�� .earsffdralis        afdr p  f   0 1��  ��  ��   n o      ���� 0 mypath myPath l  q r q r   : E s t s n   : A u v u 1   = A��
�� 
psxp v o   : =���� 0 mypath myPath t o      ���� 0 myposixpath myPosixPath r  w x w r   F Y y z y I  F U�� {��
�� .sysoexecTEXT���     TEXT { b   F Q | } | b   F M ~  ~ m   F I � � � � �  d i r n a m e   "  o   I L���� 0 myposixpath myPosixPath } m   M P � � � � �  "��   z o      ���� 0 parent_folder   x  � � � l  Z Z�� � ���   � N H if the grep below fails then this droplet is in a non standard location    � � � � �   i f   t h e   g r e p   b e l o w   f a i l s   t h e n   t h i s   d r o p l e t   i s   i n   a   n o n   s t a n d a r d   l o c a t i o n �  � � � I  Z q�� ���
�� .sysoexecTEXT���     TEXT � b   Z m � � � b   Z i � � � b   Z e � � � b   Z a � � � m   Z ] � � � � �  e c h o   " � o   ] `���� 0 parent_folder   � m   a d � � � � �  "   |   g r e p   " � o   e h���� 0 path_from_root   � m   i l � � � � �  "��   �  ��� � r   r � � � � I  r ��� ���
�� .sysoexecTEXT���     TEXT � b   r � � � � b   r � � � � b   r } � � � b   r y � � � m   r u � � � � �  e c h o   " � o   u x���� 0 parent_folder   � m   y | � � � � � . "   |   a w k   ' B E G I N   {   F S   =   " � o   } ����� 0 path_from_root   � m   � � � � � � � & "   }   ;   {   p r i n t   $ 1   } '��   � o      ���� *0 printersetup_folder printerSetup_folder��   b R      ������
�� .ascrerr ****      � ****��  ��   c k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���   `  ��� � Z   � � � ����� � =  � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �   � k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���  ��  ��  ��  ��  ��   W  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   �   Set some varibles    � � � � $   S e t   s o m e   v a r i b l e s �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� ^0 -prtinersetup_import_cups_script_name_and_path -prtinerSetup_import_cups_script_name_and_path � o      ���� B0 prtinersetup_import_cups_script prtinerSetup_import_cups_script �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� .0 printersetup_log_name printerSetup_Log_name � o      ���� $0 printersetup_log printerSetup_Log �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �  / � o   � ����� 00 printersetupfiles_name printerSetupFiles_name � o      ���� .0 printersetupfiles_dir PrinterSetupFiles_dir �  � � � l  � ���������  ��  ��   �  � � � Q   �X � � � � k   �7 � �  � � � I  � ��� ���
�� .sysoexecTEXT���     TEXT � b   � � � � � b   � � � � � m   � � � � � � �  t o u c h   " � o   � ����� $0 printersetup_log printerSetup_Log � m   � � � � � � �  "��   �  � � � I  � ��� ���
�� .sysoexecTEXT���     TEXT � b   � � � � � b   � � � � � m   � � � � � � � j e c h o   " # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # "   > >   " � o   � ����� $0 printersetup_log printerSetup_Log � m   � � � � � � �  "��   �    I  � �����
�� .sysoexecTEXT���     TEXT b   � � b   � � m   � � �   e c h o   ` d a t e `   > >   " o   � ����� $0 printersetup_log printerSetup_Log m   � �		 �

  "��    I  ����
�� .sysoexecTEXT���     TEXT b   	 b    m    �  e c h o   " "   > >   " o  ���� $0 printersetup_log printerSetup_Log m   �  "��    I ����
�� .sysoexecTEXT���     TEXT b   b   m   � r e c h o   " G e n e r a t i n g   P S F   F i l e s   F r o m   L o c a l   C U P S   P r i n t e r s "   > >   " o  ���� $0 printersetup_log printerSetup_Log m   �    "��   !"! I )��#��
�� .sysoexecTEXT���     TEXT# b  %$%$ b  !&'& m  (( �)) r e c h o   " = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = "   > >   "' o   ���� $0 printersetup_log printerSetup_Log% m  !$** �++  "��  " ,��, I *7��-��
�� .sysoexecTEXT���     TEXT- b  *3./. b  */010 m  *-22 �33  e c h o   " "   > >   "1 o  -.���� $0 printersetup_log printerSetup_Log/ m  /244 �55  "��  ��   � R      ��~�}
� .ascrerr ****      � ****�~  �}   � k  ?X66 787 I ?V�|9:
�| .sysodlogaskr        TEXT9 m  ?B;; �<< > E r r o r   :   U n a b l e   t o   O p e n   L o g   F i l e: �{=>
�{ 
btns= J  EJ?? @�z@ m  EHAA �BB  O K�z  > �yC�x
�y 
dfltC m  MPDD �EE  O K�x  8 F�wF  S  WX�w   � GHG l YY�v�u�t�v  �u  �t  H IJI l YY�sKL�s  K  open the log file   L �MM " o p e n   t h e   l o g   f i l eJ NON O  Y�PQP k  _�RR STS I _d�r�q�p
�r .miscactvnull��� ��� null�q  �p  T UVU Q  e~WX�oW I hu�nY�m
�n .sysoexecTEXT���     TEXTY b  hqZ[Z b  hm\]\ m  hk^^ �__  O p e n   "] o  kl�l�l $0 printersetup_log printerSetup_Log[ m  mp`` �aa  "�m  X R      �k�j�i
�k .ascrerr ****      � ****�j  �i  �o  V b�hb l �g�f�e�g  �f  �e  �h  Q m  Y\cc�                                                                                      @ alis    F  Macintosh HD                   BD ����Console.app                                                    ����            ����  
 cu             	Utilities   ,/:System:Applications:Utilities:Console.app/    C o n s o l e . a p p    M a c i n t o s h   H D  )System/Applications/Utilities/Console.app   / ��  O ded l ���d�c�b�d  �c  �b  e fgf l ���ahi�a  h    open the output directory   i �jj 4   o p e n   t h e   o u t p u t   d i r e c t o r yg klk O  ��mnm k  ��oo pqp I ���`�_�^
�` .miscactvnull��� ��� null�_  �^  q r�]r Q  ��st�\s k  ��uu vwv r  ��xyx 4  ���[z
�[ 
psxfz l ��{�Z�Y{ m  ��|| �}} � / U s e r s / h e n r i / D o c u m e n t s / P r o j e c t s / P r i n t e r s _ S e t u p / P r o d u c t i o n / P r i n t e r S e t u p _ v 0 0 3 4 / P r i n t e r S e t u p F i l e s�Z  �Y  y o      �X�X "0 printer_setup_files_apple_path  w ~�W~ I ���V�U
�V .aevtodocnull  �    alis o  ���T�T "0 printer_setup_files_apple_path  �U  �W  t R      �S�R�Q
�S .ascrerr ****      � ****�R  �Q  �\  �]  n m  �����                                                                                  MACS  alis    @  Macintosh HD                   BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  l ��� l ���P�O�N�P  �O  �N  � ��� l ���M�L�K�M  �L  �K  � ��� l ���J���J  �   dump some logs   � ���    d u m p   s o m e   l o g s� ��� Q  �Y���� k  ���� ��� I ���I��H
�I .sysoexecTEXT���     TEXT� b  ����� b  ����� b  ����� b  ����� b  ����� b  ����� b  ����� m  ���� ���  "� o  ���G�G B0 prtinersetup_import_cups_script prtinerSetup_import_cups_script� m  ���� ���  "  � m  ���� ���  "� o  ���F�F .0 printersetupfiles_dir PrinterSetupFiles_dir� m  ���� ���  "   |   t e e   - a i     "� o  ���E�E $0 printersetup_log printerSetup_Log� m  ���� ���  "�H  � ��� I ���D��C
�D .sysoexecTEXT���     TEXT� b  ����� b  ����� m  ���� ���  e c h o   " "   > >   "� o  ���B�B $0 printersetup_log printerSetup_Log� m  ���� ���  "�C  � ��A� l ���@�?�>�@  �?  �>  �A  � R      �=�<�;
�= .ascrerr ****      � ****�<  �;  � k  �Y�� ��� l ���:�9�8�:  �9  �8  � ��� r  ���� I ��7��
�7 .sysodlogaskr        TEXT� m  ���� ��� � A n   e r r o r   o c c o r e d   w h i l e   g e n e r a t i n g   P S F   f i l e s   f r o m   l o c a l   C U P S   p r i n t   q u e u e s :   
 
� �6��
�6 
btns� J  ���� ��� m  ���� ��� B D i s p l a y   E r r o r   D e t a i l s   i n   T e r m i n a l� ��5� m  ���� ���  U n d e r s t o o d�5  � �4��
�4 
dflt� m  ���� ���  U n d e r s t o o d� �3��
�3 
appr� m  �� ��� 6 E R R O R   I m p o r t i n g   C U P S   Q u e u e s� �2��
�2 
givu� m  �1�1  � �0��/
�0 
disp� m  �.
�. stic   �/  � o      �-�- 0 dialogresult dialogResult� ��� l �,�+�*�,  �+  �*  � ��� Z  W���)�(� = $��� n   ��� 1   �'
�' 
bhit� o  �&�& 0 dialogresult dialogResult� m   #�� ��� B D i s p l a y   E r r o r   D e t a i l s   i n   T e r m i n a l� Q  'S���%� O *J��� I 0I�$��#
�$ .coredoscnull��� ��� ctxt� b  0E��� b  0A��� b  0?��� b  0;��� b  07��� m  03�� ���  "� o  36�"�" B0 prtinersetup_import_cups_script prtinerSetup_import_cups_script� m  7:�� ���  "  � m  ;>�� ���  "� o  ?@�!�! .0 printersetupfiles_dir PrinterSetupFiles_dir� m  AD�� ���  "�#  � m  *-���                                                                                      @ alis    J  Macintosh HD                   BD ����Terminal.app                                                   ����            ����  
 cu             	Utilities   -/:System:Applications:Utilities:Terminal.app/     T e r m i n a l . a p p    M a c i n t o s h   H D  *System/Applications/Utilities/Terminal.app  / ��  � R      � ��
�  .ascrerr ****      � ****�  �  �%  �)  �(  � ��� l XX����  �  �  �  � ��� l ZZ����  �  �  � ��� l ZZ����  �  �  �     S  Z[  l \\����  �  �   � l \\����  �  �  �  ��  ��   I  l     ���
�  �  �
    l     �	���	  �  �   	
	 l     ����  �  �  
  l     ����  �  �   �  i      I      �������� 20 .display_error_determining_printer_setup_folder  ��  ��   k       l     ��������  ��  ��   �� I    ����
�� .sysodlogaskr        TEXT m      �D E r r o r   D e t e r m i n i n g   P r i n t e r   S e t u p   F o l d e r .   
 
 Y o u   m a y   n e e d   t o   c o n f i g u r e   t h i s   s c r i p t ,   a s   i t   m a y   h a v e   b e e n   m o v e d   f r o m   i t s   o r i g i n a l   l o c a t i o n   i n   t h e   ' E x a m p l e F i l e s '   f o l d e r��  ��  �        ����   ������ 20 .display_error_determining_printer_setup_folder  
�� .aevtoappnull  �   � **** ���������� 20 .display_error_determining_printer_setup_folder  ��  ��     ��
�� .sysodlogaskr        TEXT�� �j  ��������
�� .aevtoappnull  �   � **** k    b  
    !!  ""  &##  -$$  4%%  ;&&  H����  ��  ��     _ �� �� �� +�� 2�� 9�� @�� \ i���������� � ����� � � � � � ������� � ��� � � � � � �	(*24;��A��D����c��^`���|���������������������������������������� ^0 -prtinersetup_import_cups_script_name_and_path -prtinerSetup_import_cups_script_name_and_path�� .0 printersetup_log_name printerSetup_Log_name�� 00 printersetupfiles_name printerSetupFiles_name�� *0 printersetup_folder printerSetup_folder�� *0 printersetup_script printerSetup_script�� $0 printersetup_log printerSetup_Log�� .0 printersetupfiles_dir PrinterSetupFiles_dir�� 0 path_from_root  
�� .earsffdralis        afdr�� 0 mypath myPath
�� 
psxp�� 0 myposixpath myPosixPath
�� .sysoexecTEXT���     TEXT�� 0 parent_folder  ��  ��  �� 20 .display_error_determining_printer_setup_folder  �� B0 prtinersetup_import_cups_script prtinerSetup_import_cups_script
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT
�� .miscactvnull��� ��� null
�� 
psxf�� "0 printer_setup_files_apple_path  
�� .aevtodocnull  �    alis
�� 
appr
�� 
givu
�� 
disp
�� stic   �� 
�� 0 dialogresult dialogResult
�� 
bhit
�� .coredoscnull��� ��� ctxt��c�E�O�E�O�E�O�E�O�E�O�E�O�E�OEhZ��  � f�E` O)j E` O_ a ,E` Oa _ %a %j E` Oa _ %a %_ %a %j Oa _ %a %_ %a %j E�W X   *j+ !OO�a "  *j+ !OY hY hO�a #%�%E` $O�a %%�%E�O�a &%�%E�O fa '�%a (%j Oa )�%a *%j Oa +�%a ,%j Oa -�%a .%j Oa /�%a 0%j Oa 1�%a 2%j Oa 3�%a 4%j W  X   a 5a 6a 7kva 8a 9a : ;OOa < #*j =O a >�%a ?%j W X   hOPUOa @ (*j =O )a Aa B/E` CO_ Cj DW X   hUO 4a E_ $%a F%a G%�%a H%�%a I%j Oa J�%a K%j OPW vX   a La 6a Ma Nlva 8a Oa Pa Qa Rja Sa Ta U ;E` VO_ Va W,a X  1 %a Y a Z_ $%a [%a \%�%a ]%j ^UW X   hY hOPOOP[OY��ascr  ��ޭ