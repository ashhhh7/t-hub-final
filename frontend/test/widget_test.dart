import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/state/app_state.dart';
import 'package:frontend/models/bet_model.dart';
import 'package:frontend/models/squad_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App renders LoginScreen cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const PskStudentApp(),
      ),
    );

    expect(find.text('Welcome to PSK Hub'), findsOneWidget);
    expect(find.text('LOGIN & CONTINUE'), findsOneWidget);
  });

  test('Student 50% Loss Refund unit test', () {
    final appState = AppState();
    appState.login(username: 'TestStudent', isStudent: true);

    // Initial balance: 125.0
    final initialBalance = appState.user.balance;
    const stake = 20.0;

    // Add selection and place ticket
    appState.toggleSelection(
      const BetSelection(
        fixtureId: 'fix_test',
        fixtureName: 'Team A vs Team B',
        league: 'Test League',
        marketName: '1X2',
        selectionName: 'Team A',
        odds: 2.0,
      ),
    );

    final ticket = appState.placeTicket(stake);
    expect(ticket, isNotNull);
    expect(appState.user.balance, equals(initialBalance - stake));

    // Resolve as lost -> 50% of stake (€10.0) must be refunded!
    final res = appState.resolveTicket(ticket!.ticketId, false);
    expect(res['won'], isFalse);
    expect(res['refundAmount'], equals(10.0));
    expect(appState.user.balance, equals(initialBalance - stake + 10.0));
    expect(appState.user.totalLossRefunded, greaterThanOrEqualTo(10.0));
  });

  test('Squad Battle 2x Double Win unit test', () {
    final appState = AppState();
    final battle = appState.squadBattles.first;
    final initialBalance = appState.user.balance;

    final entered = appState.enterSquadBattle(battle.battleId);
    expect(entered, isTrue);
    expect(appState.user.balance, equals(initialBalance - battle.entryStakePerPlayer));

    // Simulate victory -> 2x double payout awarded!
    final res = appState.claimSquadBattleResult(battle.battleId, userTeamWon: true);
    expect(res['won'], isTrue);
    expect(res['payout'], equals(battle.doubleWinPayout));
    expect(appState.user.balance, equals(initialBalance - battle.entryStakePerPlayer + battle.doubleWinPayout));
  });

  test('Friend Invite & Squad Join unit test', () {
    final appState = AppState();
    final mySquad = appState.currentSquad;
    final initialMemberCount = mySquad.membersCount;

    // Send invite to a campus friend
    final invite = appState.sendSquadInvite(
      friendName: 'Marta_FSB',
      friendUni: 'University of Zagreb (FSB)',
    );

    expect(invite.status, equals(InviteStatus.pending));
    expect(appState.sentInvites.length, equals(1));

    // Friend accepts the invitation
    final accepted = appState.friendAcceptsInvite(invite.id);
    expect(accepted, isTrue);
    expect(invite.status, equals(InviteStatus.accepted));

    // Squad roster must have increased by 1 and contain Marta_FSB
    expect(mySquad.membersCount, equals(initialMemberCount + 1));
    expect(mySquad.memberNames.contains('Marta_FSB'), isTrue);
  });
}
