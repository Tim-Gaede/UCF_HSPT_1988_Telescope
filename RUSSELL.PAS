
{$C+}
{$U+}
{$R+}

Const Epsilon = 0.01;

Type Point = Record
               x,y,z : Real;
             End;

     AnyString = String[255];

Var
     s,c, HowFar : Real;
     Russell, Look, Spot : Point;
     Yield : Array [1..3] of Point;

     Slope12, Slope23, SlopeS1, SlopeS3 : Real;

     Infile, Outfile : Text;


Procedure GetPoint( Var p : Point);
Begin
  Readln(Infile, p.x, p.y, p.z);
End;

Procedure WritePoint( p : Point );
Begin
  Write(Outfile, '(',p.x:4:1,',',p.y:4:1,',',p.z:4:1,')');
End;

Function Sine (a,b : Real) : Real;
Begin

  Sine := b / sqrt( a * a + b * b);

End;

Function Cosine (a,b : Real) : Real;
Begin

  Cosine := a / sqrt( a * a + b * b);

End;

Function Slope( p1, p2 : Point ) : Real;
Begin

  If Abs(p1.y - p2.y) < Epsilon Then
    Slope := 0.0
  Else
    Slope := (p1.x - p2.x) / (p1.y - p2.y);

End;

Procedure RotateXY( Var p : Point; s,c : Real);
Var NewPoint : Point;
Begin

  NewPoint.x := p.x * c - p.y * s;
  NewPoint.y := p.y * c + p.x * s;
  NewPoint.z := p.z;

  p := NewPoint;

End;

Procedure RotateXZ( Var p : Point; s,c : Real);
Var NewPoint : Point;
Begin

  NewPoint.x := p.x * c - p.z * s;
  NewPoint.z := p.z * c + p.x * s;
  NewPoint.y := p.y;

  p := NewPoint;

End;

Procedure RotateYZ( Var p : Point; s,c : Real);
Var NewPoint : Point;
Begin

  NewPoint.y := p.y * c - p.z * s;
  NewPoint.z := p.z * c + p.y * s;
  NewPoint.x := p.x;

  p := NewPoint;

End;

Procedure Translate( Var p1, p2 : Point);
Begin

  p1.x := p1.x - p2.x;
  p1.y := p1.y - p2.y;
  p1.z := p1.z - p2.z;

End;

Begin

  Assign(Infile, 'russell.in' );
  Reset(Infile);

  Assign(Outfile, 'russell.out' );
  Rewrite(Outfile);

  While Not EOF(Infile) do Begin
    GetPoint(Yield[1]);
    GetPoint(Yield[2]);
    GetPoint(Yield[3]);
    GetPoint(Russell);
    GetPoint(Look);

    Write(Outfile, 'Yield sign at: ');
    WritePoint( Yield[1] );
    WritePoint( Yield[2] );
    WritePoint( Yield[3] );
    Writeln(Outfile);

    Write(Outfile, 'Russell at ');
    WritePoint( Russell );
    Write(Outfile, ' looking at ');
    WritePoint( Look );
    Writeln(Outfile);

    Translate(Yield[2], Yield[1]);
    Translate(Yield[3], Yield[1]);
    Translate(Russell, Yield[1]);
    Translate(Look, Yield[1]);
    Translate(Yield[1], Yield[1]);

    If Abs(Yield[3].z) > Epsilon Then Begin

      s := -Sine( Yield[3].x, Yield[3].z );
      c := Cosine( Yield[3].x, Yield[3].z );

      RotateXZ(Yield[2], s, c);
      RotateXZ(Yield[3], s, c);
      RotateXZ(Russell, s, c);
      RotateXZ(Look, s, c);

    End;

    If Abs(Yield[3].y) > Epsilon Then Begin

      s := -Sine( Yield[3].x, Yield[3].y );
      c := Cosine( Yield[3].x, Yield[3].y );

      RotateXY(Yield[2], s, c);
      RotateXY(Yield[3], s, c);
      RotateXY(Russell, s, c);
      RotateXY(Look, s, c);

    End;

    s := -Sine( Yield[2].y, Yield[2].z );
    c := Cosine( Yield[2].y, Yield[2].z );

    RotateYZ(Yield[2], s, c);
    RotateYZ(Yield[3], s, c);
    RotateYZ(Russell, s, c);
    RotateYZ(Look, s, c);

    If Russell.z * Look.z > Epsilon Then
      Writeln(Outfile,'Yes, Russell can see the position')

    Else Begin
      HowFar := Abs( Russell.z / (Russell.z - Look.z) ) ;
      Spot.x := HowFar * Russell.x + (1.0 - HowFar) * Look.x;
      Spot.y := HowFar * Russell.y + (1.0 - HowFar) * Look.y;
      Spot.z := 0.0;

      If Spot.y * Yield[2].y < Epsilon Then
        Writeln(Outfile,'Yes, Russell can see the position')

      Else Begin

        Spot.y := Abs(Spot.y);
        Yield[2].y := Abs(Yield[2].y);

        Slope12 := Slope(Yield[1], Yield[2]);
        Slope23 := Slope(Yield[2], Yield[3]);

        SlopeS1 := Slope( Spot, Yield[1]);
        SlopeS3 := Slope( Spot, Yield[3]);

        If (SlopeS1 > Slope12) And (SlopeS3 < Slope23) Then
             Writeln(Outfile,'No, Russell cannot see the position')
        Else
             Writeln(Outfile,'Yes, Russell can see the position')

      End;

    End;

    Writeln(Outfile);

  End;

End.


