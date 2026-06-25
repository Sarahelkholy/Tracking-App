import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/use_case/add_new_password_use_case.dart';
import 'package:flower_driver/features/auth/domain/use_case/enter_email_use_case.dart';
import 'package:flower_driver/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_cubit_test.mocks.dart';

@GenerateMocks([EnterEmailUseCase, VerifyOtpUseCase, AddNewPasswordUseCase])
void main() {
  late ForgetPasswordCubit cubit;

  late MockEnterEmailUseCase mockEnterEmailUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockAddNewPasswordUseCase mockAddNewPasswordUseCase;

  late String errorMessage;

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<bool>>(Success<bool>(data: true));
  });

  setUp(() {
    mockEnterEmailUseCase = MockEnterEmailUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockAddNewPasswordUseCase = MockAddNewPasswordUseCase();

    cubit = ForgetPasswordCubit(
      mockEnterEmailUseCase,
      mockVerifyOtpUseCase,
      mockAddNewPasswordUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group("Forget Password Cubit Test Group", () {
    test("initial state should be ForgetPasswordState", () {
      expect(cubit.state, const ForgetPasswordState());
    });

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "send email success",
      setUp: () {
        when(
          mockEnterEmailUseCase(email: anyNamed('email')),
        ).thenAnswer((_) async => Success<bool>(data: true));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(SendEmailEvent(email: "test@test.com"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          emailParam: "test@test.com",
        ),

        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          resendSecondsParam: 30,
          emailParam: "test@test.com",
        ),

        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isSuccess: true),
          resendSecondsParam: 30,
          emailParam: "test@test.com",
        ),
      ],
      verify: (_) {
        verify(mockEnterEmailUseCase(email: anyNamed('email'))).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "send email failure",
      setUp: () {
        when(
          mockEnterEmailUseCase(email: anyNamed('email')),
        ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(SendEmailEvent(email: "test@test.com"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          emailParam: "test@test.com",
        ),
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: BaseState(errorMessage: errorMessage),
          emailParam: "test@test.com",
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "verify otp success",
      setUp: () {
        when(
          mockVerifyOtpUseCase(otp: anyNamed('otp')),
        ).thenAnswer((_) async => Success<bool>(data: true));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(VerifyOtpEvent(otp: "123456"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          verifyOtpStateParam: const BaseState(isLoading: true),
        ),
        const ForgetPasswordState().copyWith(
          verifyOtpStateParam: const BaseState(isSuccess: true),
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "verify otp failure",
      setUp: () {
        when(
          mockVerifyOtpUseCase(otp: anyNamed('otp')),
        ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(VerifyOtpEvent(otp: "123456"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          verifyOtpStateParam: const BaseState(isLoading: true),
        ),
        const ForgetPasswordState().copyWith(
          verifyOtpStateParam: BaseState(errorMessage: errorMessage),
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "resend otp success",
      setUp: () {
        when(
          mockEnterEmailUseCase(email: anyNamed('email')),
        ).thenAnswer((_) async => Success<bool>(data: true));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(ResendOtpEvent(email: "test@test.com"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          emailParam: "test@test.com",
        ),

        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          resendSecondsParam: 30,
          emailParam: "test@test.com",
        ),

        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isSuccess: true),
          resendSecondsParam: 30,
          emailParam: "test@test.com",
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "resend otp failure",
      setUp: () {
        when(
          mockEnterEmailUseCase(email: anyNamed('email')),
        ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(ResendOtpEvent(email: "test@test.com"));
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: const BaseState(isLoading: true),
          emailParam: "test@test.com",
        ),
        const ForgetPasswordState().copyWith(
          sendEmailStateParam: BaseState(errorMessage: errorMessage),
          emailParam: "test@test.com",
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "reset password success",
      setUp: () {
        when(
          mockAddNewPasswordUseCase(
            email: anyNamed('email'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => Success<bool>(data: true));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(
          ResetPasswordEvent(email: "test@test.com", newPassword: "12345678"),
        );
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          resetPasswordStateParam: const BaseState(isLoading: true),
        ),
        const ForgetPasswordState().copyWith(
          resetPasswordStateParam: const BaseState(isSuccess: true),
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      "reset password failure",
      setUp: () {
        when(
          mockAddNewPasswordUseCase(
            email: anyNamed('email'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(
          ResetPasswordEvent(email: "test@test.com", newPassword: "12345678"),
        );
      },
      expect: () => [
        const ForgetPasswordState().copyWith(
          resetPasswordStateParam: const BaseState(isLoading: true),
        ),
        const ForgetPasswordState().copyWith(
          resetPasswordStateParam: BaseState(errorMessage: errorMessage),
        ),
      ],
    );
  });
}
