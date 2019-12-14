
// Подсчет когнитивной сложности методов (выводятся только > 0).
// Не учитываются косвенные рекурсивные вызовы.

Var Nodes;
Var Tokens;
Var Result;

Var Level;
Var CognitiveComplexity;
Var CurMethod;
Var ExprLevel;

Procedure Init(BSLParser) Export
	Nodes = BSLParser.Nodes();
	Tokens = BSLParser.Tokens();
	Result = New Array;
	Level = 1;
	CognitiveComplexity = 0;
	ExprLevel = 0;
EndProcedure // Init()

Function Hooks() Export
	Var Hooks;
	Hooks = New Array;
	Hooks.Add("VisitMethodDecl");
	Hooks.Add("LeaveMethodDecl");
	Hooks.Add("VisitBinaryExpr");
	Hooks.Add("LeaveBinaryExpr");
	Hooks.Add("VisitTernaryExpr");
	Hooks.Add("VisitIfStmt");
	Hooks.Add("LeaveIfStmt");
	Hooks.Add("VisitElsIfStmt");
	Hooks.Add("VisitElseStmt");
	Hooks.Add("VisitWhileStmt");
	Hooks.Add("LeaveWhileStmt");
	Hooks.Add("VisitForStmt");
	Hooks.Add("LeaveForStmt");
	Hooks.Add("VisitForEachStmt");
	Hooks.Add("LeaveForEachStmt");
	Hooks.Add("VisitExceptStmt");
	Hooks.Add("VisitCallStmt");
	Hooks.Add("VisitGotoStmt");
	Hooks.Add("VisitBreakStmt");
	Hooks.Add("VisitContinueStmt");
	Return Hooks;
EndFunction // Hooks()

Procedure VisitMethodDecl(MethodDecl, Stack, Counters) Export
	CurMethod = MethodDecl.Sign;
EndProcedure // VisitMethodDecl()

Procedure LeaveMethodDecl(MethodDecl, Stack, Counters) Export
	If CognitiveComplexity > 0 Then
		Result.Add(StrTemplate("Когнитивная сложность метода %1() равна %2", MethodDecl.Sign.Name, CognitiveComplexity));
	EndIf;
	Level = 1;
	CognitiveComplexity = 0;
EndProcedure // LeaveMethodDecl()

Procedure VisitBinaryExpr(BinaryExpr, Stack, Counters) Export
	If ExprLevel = 0 Then // только для корневого
		List = New Array;
		BuildExprList(List, BinaryExpr);
		Operator = Undefined;
		For Each Item In List Do
			If Item <> Operator Then
				Operator = Item;
				If Operator = Tokens.Or
					Or Operator = Tokens.And Then
					CognitiveComplexity = CognitiveComplexity + 1;
				EndIf;
			EndIf;
		EndDo;
	EndIf;
	ExprLevel = ExprLevel + 1;
EndProcedure // VisitBinaryExpr()

Procedure LeaveBinaryExpr(BinaryExpr, Stack, Counters) Export
	ExprLevel = ExprLevel - 1;
EndProcedure // LeaveBinaryExpr()

Function BuildExprList(List, BinaryExpr)
	If BinaryExpr.Left.Type = Nodes.BinaryExpr Then
		BuildExprList(List, BinaryExpr.Left);
	EndIf;
	List.Add(BinaryExpr.Operator);
	If BinaryExpr.Right.Type = Nodes.BinaryExpr Then
		BuildExprList(List, BinaryExpr.Right);
	EndIf;
EndFunction // BuildExprList()

Procedure VisitTernaryExpr(TernaryExpr, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
EndProcedure // VisitTernaryExpr()

Procedure VisitCallStmt(CallStmt, Stack, Counters) Export
	If CallStmt.Ident.Head.Decl = CurMethod Then
		CognitiveComplexity = CognitiveComplexity + 1;
	EndIf;
EndProcedure // VisitCallStmt()

Procedure VisitIfStmt(IfStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
	Level = Level + 1;
EndProcedure // VisitIfStmt()

Procedure LeaveIfStmt(IfStmt, Stack, Counters) Export
	Level = Level - 1;
EndProcedure // LeaveIfStmt()

Procedure VisitElsIfStmt(ElsIfStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + 1;
EndProcedure // VisitElsIfStmt()

Procedure VisitElseStmt(ElseStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + 1;
EndProcedure // VisitElseStmt()

Procedure VisitWhileStmt(WhileStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
	Level = Level + 1;
EndProcedure // VisitWhileStmt()

Procedure LeaveWhileStmt(WhileStmt, Stack, Counters) Export
	Level = Level - 1;
EndProcedure // LeaveWhileStmt()

Procedure VisitForStmt(ForStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
	Level = Level + 1;
EndProcedure // VisitForStmt()

Procedure LeaveForStmt(ForStmt, Stack, Counters) Export
	Level = Level - 1;
EndProcedure // LeaveForStmt()

Procedure VisitForEachStmt(ForEachStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
	Level = Level + 1;
EndProcedure // VisitForEachStmt()

Procedure LeaveForEachStmt(ForEachStmt, Stack, Counters) Export
	Level = Level - 1;
EndProcedure // LeaveForEachStmt()

Procedure VisitExceptStmt(ExceptStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + Level;
	Level = Level + 1;
EndProcedure // VisitExceptStmt()

Procedure VisitGotoStmt(GotoStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + 1;
EndProcedure // VisitGotoStmt()

Procedure VisitBreakStmt(BreakStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + 1;
EndProcedure // VisitBreakStmt()

Procedure VisitContinueStmt(ContinueStmt, Stack, Counters) Export
	CognitiveComplexity = CognitiveComplexity + 1;
EndProcedure // VisitContinueStmt()

Function Result() Export
	Return StrConcat(Result, Chars.LF);
EndFunction // Result()

